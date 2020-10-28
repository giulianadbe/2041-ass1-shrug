#!/bin/dash

# test if shrug-show matches reference implementation (error messages and functionality)

# compares output of an 'out' file and 'exp' file to determine this

# 0. no commits made - error show
# 1. single commit made, try access nonexistent commit
# 2. single commit made, try access nonexistent file
# 3. single commit made, try access file with an invalid name
# 4. single commit made, try access invalid and non-existent commit name
# 5. ':' not in arg
# 6. No command arguments given to show
# 7. no commit specified, valid file
# 8. no commit specified, invalid file name
# 9. no commit specified, nonexistent file

touch d e f

## MY OUTPUT ##
./shrug-init > out
./shrug-show 0:a 2>> out
./shrug-add d >> out
./shrug-commit -m first >> out
./shrug-show 0:d >> out
./shrug-show 1:d 2>> out
./shrug-show 0:a 2>> out
./shrug-show 0:-invalid 2>> out
./shrug-show 2:-invalid 2>> out
./shrug-show -invalid:-invalid 2>> out
./shrug-add e f >> out
./shrug-commit -m second >> out
./shrug-show 1:e >> out
./shrug-show 1:d >> out
./shrug-show 1d 2>> out
./shrug-show invalid: 2>> out
./shrug-show 2>> out
./shrug-show :e >> out
./shrug-show :-invalid 2>> out
./shrug-show :nonexistent 2>> out

## CLEAR .SHRUG ##
if test -d ".shrug"
then
    rm -r .shrug/
fi

## REFERENCE OUTPUT ##
2041 shrug-init > exp
2041 shrug-show 0:a 2>> exp
2041 shrug-add d >> exp
2041 shrug-commit -m first >> exp
2041 shrug-show 0:d >> exp
2041 shrug-show 1:d 2>> exp
2041 shrug-show 0:a 2>> exp
2041 shrug-show 0:-invalid 2>> exp
2041 shrug-show 2:-invalid 2>> exp
2041 shrug-show -invalid:-invalid 2>> exp
2041 shrug-add e f >> exp
2041 shrug-commit -m second >> exp
2041 shrug-show 1:e >> exp
2041 shrug-show 1:d >> exp
2041 shrug-show 1d 2>> exp
2041 shrug-show invalid: 2>> exp
2041 shrug-show 2>> exp
2041 shrug-show :e >> exp
2041 shrug-show :-invalid 2>> exp
2041 shrug-show :nonexistent 2>> exp


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
