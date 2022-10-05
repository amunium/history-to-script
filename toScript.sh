#!/bin/bash

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

    history $number > temp.txt
    historyClean=$(sed $d temp.txt)
    output=$(echo $historyDump | sed -E /[0-9]{4}/d)

    echo $output
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