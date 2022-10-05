#!/bin/bash

# add trap to temp1 and temp0 files
trap finish EXIT

function finish {
	rm -rf "temp0.txt"
	rm -rf "temp1.txt"
	kill 0
}

answer="a"
while [ $answer != "y" ]
do
    number="a"
    while (echo $number | grep -qE "[^0-9]+")
    do
        echo -n "Please enter how far back you want to go: "
        read number
        if (echo $number | grep -qE "[^0-9]+")
        then
            echo "$number is not an accepted number."
        fi
    done

    # enable bash history
    HISTFILE=~/.bash_history
    set -o history
    history $number > temp0.txt
    
    # clean history
    sed -E 's/\s[0-9]+\s\s//' temp0.txt > temp1.txt
    

    cat  "./temp1.txt"
    echo "Is this the correct script? (y/n) "
    echo -n ">>> "
    read answer
    if [ $answer != "y" ]
    then
        echo "Take corrective actions? (y/n)"
        echo -n ">>> "
        read corrective
        if [ $corrective = "y" ]
        then
            echo "Remove the last line? (y/n)"
            echo -n ">>> "
            read rmLast
            while [ $rmLast = "y" ]
            do
                echo "Removing last line:"
                sed -i '$d' temp1.txt
                cat temp1.txt
                echo "Remove another?"
                echo -n ">>> "
                read rmLast
            done
            echo "Remove the first line? (y/n)"
            echo -n ">>> "
            read rmFirst
            while [ $rmFirst = "y" ]
            do
                echo "Removing first line:"
                sed -i '1d' temp1.txt
                cat temp1.txt
                echo "Remove another?"
                echo -n ">>> "
                read rmFirst
            done
        fi
        echo "Do you want to save as file? (y/n)"
        echo -n ">>> "
        read answer
        if [ $answer != "y" ]
        then
            echo "Do you want to restart? (y/n)"
            echo -n ">>> "
            read goBack
            if [ $goBack != "y" ]
            then
                kill 0 # exit point
            fi
        fi
    fi
done

echo "What do you want to name the script? "
echo -n ">>> "
read scriptName
if ( echo $scriptName | grep -qoE ".sh$" )
then
    cat temp1.txt > $scriptName
else
    cat temp1.txt > $scriptName.sh
fi

echo "History has been canned."