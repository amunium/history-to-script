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

    # clean input - Not the most beautiful solution
    history $number+1 > temp0.txt
    sed '$d' temp0.txt > temp1.txt
    sed -E '/^\s[0-9]{4}\s{2}/d' temp1.txt > temp0.txt

    cat temp.txt
    echo "Is this the correct script? (y/n) "
    echo -n ">>> "
    read answer
    if [ answer != "y" ]
    then
        number="a"
    fi
done

echo "what do you want to name the script? "
echo -n ">>> "
read scriptName
if [ echo $scriptName | grep -qoE ".sh$" ]
then
    echo $output > $scriptName
else
    echo $output > $scriptName.sh
fi