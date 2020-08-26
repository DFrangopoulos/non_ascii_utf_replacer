#!/bin/bash
echo "Checking for sample name list"
test -e names.list && echo "Sample name list found!" || exit
echo "Checking input file"
test -e $1 && echo "Valid input file" || exit

cp "$1" "out_$1"

cat $1 | sed -r 's|(.)|\1\x00|g' | tr -d '\001-\177' | sed -r 's|\x00\x00|\x0a|g' | sort | tr -d '\000' | sed '/^$/d' | awk '{print length , $0}' | sort -s -b -k 1nr |  cut -d" " -f2 > dictionary

num=$(wc -l dictionary | cut -d" " -f1); for i in $(eval echo {1..$num}); do  c=$(head -n"$i" dictionary | tail -n1); e=$(head -n"$i" names.list | tail -n1); sed -ri "s/$c/$e/g" "out_$1" ; done

test -e dictionary && rm dictionary

test -e "out_$1" && echo "Ready!"
