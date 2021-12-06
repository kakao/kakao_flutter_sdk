#!/bin/bash
filename='package_list.txt'

branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [[ $branch != "release"* ]] && [[ $branch != "hotfix"* ]]; then
    echo "The current branch must be release or hotfix!"
    exit
fi

version=""

if [[ $branch == "release"* ]]; then
    version=${branch:8}
elif [[ $branch == "hotfix"* ]]; then
    version=${branch:7}
fi

if [[ $version != *.*.* ]]; then
    echo "The current branch must contains version!"
    exit
fi

melos list -a > $filename

while read -r line; do
    melos version "$line" "$version" --yes --no-changelog
done < $filename

rm $filename

