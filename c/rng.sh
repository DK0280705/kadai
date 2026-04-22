#!/usr/bin/env bash
# random_array.sh ─ generate an array of random integers
# Usage: ./random_array.sh [COUNT] [MIN] [MAX]
#   COUNT – how many numbers to generate   (default: 10)
#   MIN   – lowest value (inclusive)       (default: 0)
#   MAX   – highest value (inclusive)      (default: 32767)

count=${1:-10}
min=${2:-0}
max=${3:-32767}

if (( max < min )); then
  echo "Error: MAX must be ≥ MIN" >&2
  exit 1
fi

range=$(( max - min + 1 ))

for (( i=0; i<count; i++ )); do
  printf '%d\n' $(( RANDOM % range + min ))
done

printf "\n"
