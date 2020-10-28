#!/bin/dash

# test if shrug-add matches reference implementation - interesting error cases
# - try pass no args in
# - try pass in args that arent valid file names and dont exist
# - try pass in args that arent valid file names but do exist
# - try pass in args where one file is valid and one isnt
# - try pass in directory
# - try pass in a file that previously existed and was removed

# compares output of an 'out' file and 'exp' file to determine this

touch a b c ...d

## MY OUTPUT ##
./shrug-init > out
./shrug-add 2>> out
./shrug-add -test 2>> out
./shrug-add ...d 2>> out
./shrug-add a e 2>> out
./shrug-add ./tests 2>> out
rm a
./shrug-add a 2>> out


## CLEAR .SHRUG ##
if test -d ".shrug"
then
    rm -r .shrug/
fi

touch a

## REFERENCE OUTPUT ##
2041 shrug-init > exp
2041 shrug-add 2>> exp
2041 shrug-add -test 2>> exp
2041 shrug-add ...d 2>> exp
2041 shrug-add a e 2>> exp
2041 shrug-add ./tests 2>> exp
rm a
2041 shrug-add a 2>> exp

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
