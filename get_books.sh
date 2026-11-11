#!/bin/bash
set -euo pipefail

bucket="$1"
book_dir="$2"

# create the book directory if it does not exist
mkdir -p "$book_dir"

# copy only .txt files from the bucket, nothing else
aws s3 cp "s3://$bucket" "$book_dir" --recursive --exclude "*" --include "*.txt"

# absolute path to the book directory
abs_dir="$(realpath -s "$book_dir")"

# write book_list.txt: header first, then one absolute book path per line, sorted
echo "File path" > book_list.txt
find "$abs_dir" -name "*.txt" | sort >> book_list.txt

# count how many books were listed (exclude the header)
count="$(find "$abs_dir" -name "*.txt" | wc -l)"
echo "Listed $count books"
