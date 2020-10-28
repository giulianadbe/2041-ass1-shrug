#!/bin/dash

# test if shrug-commit matches reference implementation - interesting error cases
# 1. no args
# 2. newline in message
# 3. -m missing
# 4. no files in index
# 5. stage the same as last commit
# 6. -m then -a
# 7. -m then message then -a --> interesting case in ref implementation (actually allows commit)
# 8. double message
# 9. "" message

# compares output of an 'out' file and 'exp' file to determine this

## MY OUTPUT ##
newline='\
 '
./shrug-init > out
./shrug-commit 2>> out
./shrug-commit -m "$newline" 2>> out
./shrug-commit hello 2>> out
./shrug-commit -m first >> out
./shrug-commit -m -a hello 2>> out
./shrug-commit -m message -a >> out
./shrug-commit -m two messages 2>> out
./shrug-commit -m "" 2>> out

## CLEAR .SHRUG ##
if test -d ".shrug"
then
    rm -r .shrug/
fi

## REFERENCE OUTPUT ##
2041 shrug-init > exp
2041 shrug-commit 2>> exp
2041 shrug-commit -m "$newline" 2>> exp
2041 shrug-commit hello 2>> exp
2041 shrug-commit -m first >> exp
2041 shrug-commit -m -a hello 2>> exp
2041 shrug-commit -m message -a >> exp
2041 shrug-commit -m two messages 2>> exp
2041 shrug-commit -m "" 2>> exp

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
