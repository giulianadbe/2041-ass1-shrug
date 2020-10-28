#!/bin/dash

# test if shrug-rm matches reference implementation - rm errors...
# tests invalid filenames, options and arguments

# 1. no commits made
# 2. no file that matches arg in cwd or index
# 3. no file matches arg in index
# 4. no arguments given
# 5. filename that is a string
# 6. --cached then --force

# compares output of an 'out' file and 'exp' file to determine this

touch a b c
>a
touch "this is a long filename"

## MY OUTPUT ##
./shrug-init > out
./shrug-rm a 2>> out
./shrug-add a b >> out
./shrug-commit -m first >> out
./shrug-rm unknown 2>> out
rm a
./shrug-rm --cached a >> out
./shrug-rm a 2>> out
./shrug-rm 2>> out
./shrug-add "this is a long filename" 2>> out
./shrug-rm "this is a long filename" 2>> out
./shrug-rm --cached --force b 2>> out

## CLEAR .SHRUG ##
if test -d ".shrug"
then
    rm -r .shrug/
fi

touch a b c
touch "this is a long filename"
>a

## REFERENCE OUTPUT ##
2041 shrug-init > exp
2041 shrug-rm a 2>> exp
2041 shrug-add a >> exp
2041 shrug-commit -m first >> exp
2041 shrug-rm unknown 2>> exp
rm a
2041 shrug-rm --cached a >> exp
2041 shrug-rm a 2>> exp
2041 shrug-rm 2>> exp
2041 shrug-add "this is a long filename" 2>> exp
2041 shrug-rm "this is a long filename" 2>> exp
2041 shrug-rm --cached --force 2>> exp

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
