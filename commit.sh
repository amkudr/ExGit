#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: $0 <task_id> <commit_message>"
    exit 1
fi

CURR_TASK_ID=$1
EXTRA_COMMIT_MESSAGE=$2
IS_PUSH=false

if [[ " $* " == *" -p "* ]]; then
    IS_PUSH=true
fi

EXEL_PATH="tasks.csv"

if [ ! -f $EXEL_PATH ]; then
    echo "Error: $EXEL_PATH not found."
    exit 1
fi

while IFS=',', read -r TaskID Desc branch Developer GITHUB_URL; do
    if [[ "$TaskID" =~ ^[0-9]+$ ]]; then           # check if TaskID is a number
        if [ "$TaskID" -eq "$CURR_TASK_ID" ]; then # check if TaskID is equal to the given TaskID

            commit_message="$TaskID - $(date '+%Y-%m-%d %H:%M:%S') - $branch - $Developer - $Desc - $EXTRA_COMMIT_MESSAGE"

            git add .
            git commit -m "$commit_message"
            echo "Commit message: $commit_message"

            if [ "$IS_PUSH" = true ]; then
                git push origin $branch
                echo "Pushed to $branch"
            fi

            break
        fi
    fi

done <$EXEL_PATH
