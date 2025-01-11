#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: $0 <task_id> <commit_message> [folder_path]"
    exit 1
fi


FOLDER_PATH="."
IS_PUSH=false


while getopts "p" opt; do
    case $opt in
    p)
        IS_PUSH=true
        shift $((OPTIND - 1))
        ;;
    esac
done

CURR_TASK_ID=$1
EXTRA_COMMIT_MESSAGE=$2

if [ $# -ge 3 ]; then
    FOLDER_PATH=$3
fi

if [ ! -d $FOLDER_PATH ]; then
    echo "Error: Directory $FOLDER_PATH not found."
    exit 1
fi
EXEL_PATH="tasks.csv"

if [ ! -f $EXEL_PATH ]; then
    echo "Error: $EXEL_PATH not found."
    exit 1
fi

echo $IS_PUSH

while IFS=',', read -r TaskID Desc branch Developer GITHUB_URL; do
    if [[ "$TaskID" =~ ^[0-9]+$ ]]; then           # check if TaskID is a number
        if [ "$TaskID" -eq "$CURR_TASK_ID" ]; then # check if TaskID is equal to the given TaskID
            if [ "$branch" != $(git branch --show-current) ]; then
                echo "Error: Current branch is not $branch"
                exit 1
            fi

            commit_message="$TaskID - $(date '+%Y-%m-%d %H:%M:%S') - $branch - $Developer - $Desc - $EXTRA_COMMIT_MESSAGE"

            cd "$FOLDER_PATH" 
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
