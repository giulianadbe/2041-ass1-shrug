#!/bin/dash

# test if shrug-status matches reference implementation - status errors

# 1. no .shrug
# 2. no commits made

# compares output of an 'out' file and 'exp' file to determine this

touch a b c
>a
touch "this is a long filename"

## MY OUTPUT ##
./shrug-status 2> out
./shrug-init >> out
./shrug-status 2>> out

## CLEAR .SHRUG ##
if test -d ".shrug"
then
    rm -r .shrug/
fi

touch a b c
touch "this is a long filename"
>a

## REFERENCE OUTPUT ##
2041 shrug-status 2> exp
2041 shrug-init >> exp
2041 shrug-status 2>> exp

# use -wy to debug in column mode
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
