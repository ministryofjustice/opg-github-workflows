#!/usr/bin/env bash

set -e

str="$1"
suffix="$2"
max_len="$3"
conditional_match="$4"
conditional_value="$5"

suffix_len="${#suffix}"

parsed=$(echo ${str} | tr '[:upper:]' '[:lower:]')
safe=$( echo "${parsed}" | tr -cd '[:alnum:]')
trimmed=""

# If a max length as been set, then trim the string down
if [ ! -z "${max_len}" ]; then
    sub_len="$((max_len - suffix_len))"
    trimmed="${safe:0:$sub_len}${suffix}"
fi

# If conditional match equals the original string, then use the value directly
# and overwrite the trimmed / safe values
if [ ! -z "${conditional_match}" ] && [ "${str}" = "${conditional_match}" ]; then
    safe="${conditional_value}"
    trimmed="${conditional_value}"
fi

echo "original=${str}"
echo "suffix=${suffix}"
echo "length=${max_len}"
echo "safe=${safe}"
echo "trimmed=${trimmed}"

echo "original=${str}" >> $GITHUB_OUTPUT
echo "suffix=${suffix}" >> $GITHUB_OUTPUT
echo "length=${max_len}" >> $GITHUB_OUTPUT
echo "safe=${safe}" >> $GITHUB_OUTPUT
echo "trimmed=${trimmed}" >> $GITHUB_OUTPUT
