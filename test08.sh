#!/bin/dash

# test if shrug-status matches reference implementation - status functionality
# this also tests functionality of shrug-rm and shrug-add with status checking

# 1. files only in cwd
# 2. files in stage and cwd
# 3. files in cwd, stage and last repo
# 4. changed files in cwd
# 5. changed files in stage and cwd
# 6. file removed from stage
# 7. file removed from stage and cwd

# compares output of an 'out' file and 'exp' file to determine this

touch a b c d e f

## MY OUTPUT ##
./shrug-init > out
./shrug-add a b c d e >> out
./shrug-commit -m "all but one file" >> out
echo "edited" > a b
./shrug-add a >> out
./shrug-rm d >> out
rm c
./shrug-rm --cached e >> out
./shrug-status >> out


## CLEAR .SHRUG ##
if test -d ".shrug"
then
    rm -r .shrug/
fi

touch a b c d e f

## REFERENCE OUTPUT ##
2041 shrug-init > exp
2041 shrug-add a b c d e >> exp
2041 shrug-commit -m "all files but one" >> exp
echo "edited" > a b
2041 shrug-add a >> exp
2041 shrug-rm d >> exp
rm c
2041 shrug-rm --cached e >> exp
2041 shrug-status >> exp

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
