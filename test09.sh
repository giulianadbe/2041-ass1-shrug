#!/bin/dash

# test if shrug-status matches reference implementation - rm functionality
# this also tests functionality of shrug-commit and shrug-add
# runs status throughout to check deletion

# 1. remove nonexistent file
# 2. remove file from index
# 3. remove file only in cwd
# 4. remove file in cwd and index
# 5. remove file with changes made to cwd
# 6. remove file with changes made to index (not commited)
# 7. --force remove file with changes to index
# 8. try remove file twice

# compares output of an 'out' file and 'exp' file to determine this

touch a b c d e

## MY OUTPUT ##
./shrug-init > out
./shrug-add a b c d >> out
./shrug-commit -m "all files added" >> out
./shrug-rm nonexistent 2>> out
rm b
./shrug-add b >> out
./shrug-commit -m "rm from index" >> out
./shrug-rm b 2>> out
echo "change" >> a
./shrug-rm a 2>> out 
./shrug-add a 2>> out
./shrug-rm a 2>> out

## CLEAR .SHRUG ##
if test -d ".shrug"
then
    rm -r .shrug/
fi

touch a b c d e

## REFERENCE OUTPUT ##
2041 shrug-init > exp
2041 shrug-add a b c d >> exp
2041 shrug-commit -m "all files added" >> exp
2041 shrug-rm nonexistent 2>> exp
rm b
2041 shrug-add b >> exp
2041 shrug-commit -m "rm from index" >> exp
2041 shrug-rm b 2>> exp
echo "change" >> a
2041 shrug-rm a 2>> exp
2041 shrug-add a 2>> exp
2041 shrug-rm a 2>> exp

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
