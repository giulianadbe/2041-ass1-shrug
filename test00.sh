#!/bin/dash

# test if shrug-init matches reference implementation (creates only 1 .shrug)

# compares output of an 'out' file and 'exp' file to determine this

## MY OUTPUT ##
./shrug-init > out
./shrug-init 2>> out

## CLEAR .SHRUG ##
if test -d ".shrug"
then
    rm -r .shrug/
fi

## REFERENCE OUTPUT ##
2041 shrug-init > exp
2041 shrug-init 2>> exp

diff=$(diff -w "exp" "out")

if test "$diff"
then
    echo "Expected output vs actual output"
    echo "-------------------------------"
    echo "$diff"
fi

if test ! "$diff"
then
    echo "Expected output matches actual output"
fi

if test -d ".shrug"
then
    rm -rf .shrug/
fi
