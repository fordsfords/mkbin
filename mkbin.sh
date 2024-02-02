#!/bin/sh
# mkbin.sh

# This is not a shell version of the mkbin tool.
# It is just some example shell code that creates
# a binary file.

A="11"

echo -ne \\x$A\\x22 >x
echo -ne "\\x33\\x44" >>x
# Single quotes break it.
# echo -ne '\\x55\\x66' >>x

hexdump -C x
