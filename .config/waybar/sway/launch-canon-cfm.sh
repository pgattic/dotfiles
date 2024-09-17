#!/bin/bash

while read line
do
  exec foot sh -c "canon '$line' | less"
done < "${1:-/dev/stdin}"
