#!/usr/bin/env bash

set -e

str="$1"
suffix="$2"
max_len="$3"
suffix_len="${#suffix}"

parsed=$(echo ${str} | tr '[:upper:]' '[:lower:]')
safe=$( echo "${parsed}" | tr -cd '[:alnum:]')
trimmed=""

if [ ! -z "${max_len}" ]; then
    sub_len="$((max_len - suffix_len))"
    trimmed="${safe:0:$sub_len}${suffix}"
fi

echo "original=${str}" >> $GITHUB_OUTPUT
echo "suffix=${suffix}" >> $GITHUB_OUTPUT
echo "length=${max_len}" >> $GITHUB_OUTPUT
echo "safe=${safe}" >> $GITHUB_OUTPUT
echo "trimmed=${trimmed}" >> $GITHUB_OUTPUT
