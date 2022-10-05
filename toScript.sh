#!/bin/bash

# add trap to temp1 and temp0 files


number=$1
answer=""
while [ answer != "y" ]
do
    if (echo $number | grep -qoE "^[0-9]*$")
    then
        echo "Looking $number commands into history..."
    else
        while (echo $number | grep -qoE "[a-zA-Z]")
        do
            echo -n "Please enter how far back you want to go: "
            read number
            if [echo $number | grep -qoE "[a-zA-Z]"]
            then
                echo "$number is not an accepted number."
            fi
        done
    fi

    # clean history
    number=$(($number+1)) # This makes up for the command starting this script 
    history $number > temp0.txt
    sed -i '$d' temp0.txt # removes this script from history
    sed -E 's/^\s[0-9]{4}\s{2}//' temp0.txt > temp1.txt # clean
    
    cat temp1.txt

    echo "Is this the correct script? (y/n) "
    echo -n ">>> "
    read answer
    if [ $answer != "y" ]
    then
        echo
        echo "Looking for corrective actions..."
        sleep 1
        echo "Remove the last line? (y/n)"
        echo -n ">>> "
        read rmLine
        while [ $rmLine = "y" ]
        do
            echo "Removing last line:"
            sed -i '$d' temp1.txt
            cat temp1.txt
            echo "Remove another?"
            echo -n ">>> "
            read rmLine
        done
        echo "Do you want to restart?"
        echo -n ">>> "
        read goBack
        if [ $goBack = "y" ]
        then
            number="a"
        fi
    fi
done

echo "What do you want to name the script? "
echo -n ">>> "
read scriptName
if [ echo $scriptName | grep -qoE ".sh$" ]
then
    echo $output > $scriptName
else
    echo $output > $scriptName.sh
fi

echo "History has been canned."