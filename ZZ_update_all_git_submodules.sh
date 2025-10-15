#!/bin/bash

[[ -e ./helpers/update_and_commit_git_module.sh ]] || {
    echo "./helpers/update_and_commit_git_module.sh does not exist, do you need to run 'git submodule update' first?"
    exit 3
}

while read -r module
do

    ./helpers/update_and_commit_git_module.sh "${module}"

done < <(awk '/path = / {print $3}' .gitmodules)

exit 0
