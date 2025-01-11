#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <task_id> <commit_message>"
    exit 1
fi

CURR_TASK_ID=$1
EXTRA_COMMIT_MESSAGE=$2

EXEL_PATH="tasks.csv"

if [ ! -f $EXEL_PATH ]; then
    echo "Error: $EXEL_PATH not found."
    exit 1
fi



while IFS=',', read -r TaskID Desc branch Developer GITHUB_URL;
do
    if [[ "$TaskID" =~ ^[0-9]+$ ]]; then # check if TaskID is a number
        if [ "$TaskID" -eq "$CURR_TASK_ID" ]; then # check if TaskID is equal to the given TaskID

            commit_message="$TaskID - ${date} - $branch - $Developer - $Desc - $EXTRA_COMMIT_MESSAGE"

            git add .
            git commit -m "$commit_message"
            echo "Commit message: $commit_message"
            
            break
        fi
    fi

done < $EXEL_PATH

