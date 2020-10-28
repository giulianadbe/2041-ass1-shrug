#!/bin/dash

# test if shrug-log and shrug-show matches reference implementation (error messages)

# compares output of an 'out' file and 'exp' file to determine this

# 1. no commits made - error log
# 3. single commit made, log given command arguments
# 4. log output after a commit error
# 5. log output after 'nothing to commit' (not a a commit error)
# 5. double commit - log

touch d e f

## MY OUTPUT ##
./shrug-init > out
./shrug-log 2>> out
./shrug-add d >> out
./shrug-commit -m first >> out
./shrug-log >> out
./shrug-log argument 2>> out
./shrug-commit -m -a error 2>> out
./shrug-log >> out
./shrug-commit -m "nothing to commit" >> out
./shrug-log >> out
./shrug-add e f >> out
./shrug-commit -m second >> out
./shrug-log >> out

## CLEAR .SHRUG ##
if test -d ".shrug"
then
    rm -r .shrug/
fi

## REFERENCE OUTPUT ##
2041 shrug-init > exp
2041 shrug-log 2>> exp
2041 shrug-add d >> exp
2041 shrug-commit -m first >> exp
2041 shrug-log >> exp
2041 shrug-log argument 2>> exp
2041 shrug-commit -m -a error 2>> exp
2041 shrug-log >> exp
2041 shrug-commit -m "nothing to commit" >> exp
2041 shrug-log >> exp
2041 shrug-add e f >> exp
2041 shrug-commit -m second >> exp
2041 shrug-log >> exp

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
