#!/bin/bash
# Mirroring remote repo to this git server (totally deletes local repo)
#set -x #echo on

if [ -z "$1" ] || [ -z "$2" ]
then
    echo -e '\n  Usage: ./run.sh <repo-name> <repo-ip>\n'
else

    echo "$(date "+%F %H:%M:%S") Cloning repo $1"
    rm -rf ./$1.git
    ssh-agent bash -c "ssh-add ~/.ssh/reclone_rsa;  git clone --mirror --progress ssh://git@$2/$1"

    if [ ! -d "$1.git" ]; then
        echo "$(date "+%F %H:%M:%S") clone FAILED"
    else

        echo "$(date "+%F %H:%M:%S") Cd $1.git"
        cd ./$1.git

        echo "$(date "+%F %H:%M:%S") Push $1.git to localhost"
        git push --mirror --progress ssh://git@127.0.0.1/$1

        echo "$(date "+%F %H:%M:%S") Clearing"
        cd ..
        rm -rf ./$1.git
    fi

    echo "" #empty line for beautiful logs
fi