#!/usr/bin/env bash

# Copyright © 2019 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

set -e -u
set -m

for cmd in ss curl
do
    if ! command -v "$cmd" > /dev/null
    then
        echo "1..0 # skip $cmd not installed"
        exit 0
    fi
done
echo 1..1
basedir="${0%/*}/.."
pymod="$basedir/cowproxy.py"
port=$((1024 + RANDOM % 31744))
mitmdump -q -p $port -s "$pymod" &
trap 'kill %1; wait' EXIT
for i in $(seq 1 10)
do
    if ss -tln "sport = $port" | grep -w $port > /dev/null
    then
        break
    fi
    echo "# waiting for port $port..."
    sleep 1
done
export http_proxy="http://localhost:$port/"
out=$(curl --silent --fail --show-error --include http://www.example.org/cow)
sed -e 's/^/# /' <<< "$out"
if grep -F '(oo)' <<< "$out" > /dev/null
then
    echo ok 1
else
    echo not ok 1
fi

# vim:ts=4 sts=4 sw=4 et ft=sh
