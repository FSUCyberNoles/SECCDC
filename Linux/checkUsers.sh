#!/bin/bash

echo "Right arrows '>' means the user exists in users.txt but NOT in /etc/passwd"
echo "Left arrows '<' means the user exists in /etc/passwd but NOT in users.txt"
echo ""

if [ -s users.txt ]
        then diff <(cat /etc/passwd | grep -ve nologin -e false | awk -F: '{print $1}' | sort) <(cat users.txt | sort)
        exit
fi

echo "No users.txt found in current directory."
echo "Please generate a users.txt file with each username followed by a newline"