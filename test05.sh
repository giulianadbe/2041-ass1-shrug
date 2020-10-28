#!/bin/dash

# test if shrug-commit matches reference implementation - functionality of commits

# 1. no files in index
# 2. files in index same as last commit
# 3. files not in index that had contents in last commit, but changed value
# 4. all files altered, not restaged, recommitted
# 5. some files altered, restaged, recommitted

# compares output of an 'out' file and 'exp' file to determine this

touch a b c d

## MY OUTPUT ##
./shrug-init > out
./shrug-commit -m "empty index" >> out
./shrug-add a b >> out
./shrug-commit -m first >> out
./shrug-commit -m "same as last" >> out
# touch a
$(echo "alter" > a)
./shrug-add a >> out
./shrug-commit -m second >> out
$(echo "new" > a b c)
./shrug-commit -m third >> out
./shrug-add b c >> out
./shrug-commit -m fourth >> out

## CLEAR .SHRUG ##
if test -d ".shrug"
then
    rm -r .shrug/
fi

touch a b c

## REFERENCE OUTPUT ##
2041 shrug-init > exp
2041 shrug-commit -m "empty index" >> exp
2041 shrug-add a b >> exp
2041 shrug-commit -m first >> exp
2041 shrug-commit -m "same as last" >> exp
$(echo "alter" > a)
2041 shrug-add a >> exp
2041 shrug-commit -m second >> exp
$(echo "new" > a b c)
2041 shrug-commit -m third >> exp
2041 shrug-add b c >> exo
2041 shrug-commit -m fourth >> exp

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
