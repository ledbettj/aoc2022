#!/usr/bin/env bash

die() {
    echo "$1"
    exit 1
}

SESSION=$(cat ".session.txt")
DAY=$(echo -n $(date +'%e'))
URL="https://adventofcode.com/2022/day/$DAY/input"
DEST="./test/inputs/day$DAY.txt"
if [ -f "$DEST" ]; then
    die "Input for day $DAY already exists"
else
    curl "$URL" --cookie "session=$SESSION" -o "$DEST" || die "Failed to fetch input"
    echo "Saved $URL to $DEST"
fi
