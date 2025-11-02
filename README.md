# mkbin
Perl-based binary data generator.

<!-- mdtoc-start -->
&bull; [mkbin](#mkbin)  
&bull; [Usage](#usage)  
&bull; [Example](#example)  
&bull; [TODO](#todo)  
&bull; [License](#license)  
<!-- TOC created by '../mdtoc/mdtoc.pl README.md' (see https://github.com/fordsfords/mdtoc) -->
<!-- mdtoc-end -->

YAY! Another little language!

I've written this program a few times in my years,
before there was a GitHub,
and I've never been able to keep track of it.

This time for sure!

I want an easy way to create a binary file that lets me
specify its contents in hex, decimal, or ascii.

NOTE: there is also a small script "mkbin.sh".
It simply demonstrates a Bash script that writes a binary
file and relies on the -e flag for the "echo" command.
This is only periferally related to the main mkbin.pl tool.


# Usage

````
Usage: mkbin.pl [-h] [-o out_file] [file ...]
    -h - help
    -o out_file - output file (default: STDOUT).
    file ... - zero or more input files.  If omitted, inputs from stdin.

Input file commands:
  !endian=0/1 - 0=little endian, 1=big endian (a.k.a. network order; default)
  # comments and blank lines are ignored
  8d0 .. 8d255, 8d-128 - 8-bit integer specified as decimal: -128..255
  8x0 .. 8xff - 8-bit integer specified as hex: 0..ff
  16d0 .. 16d65535, 16d-32768 - 16-bit integer specified as decimal -32768..65535; endian applied
  16x0 .. 16xffff - 8-bit integer specified as hex: 0..ffff; endian applied
  32d... 32x... 64d... 64x... - 32 and 64 bit integers specified as decimal and hex; endian applied
  0x010203... - arbitrary number of bytes specified in hex (must have even number of digits)
  "ascii" - ascii characters (not null-terminated). Backslash escapes next character.

See https://github.com/fordsfords/mkbin for more information.
````

Input file consists of one or more lines,
where each line contains one or more commands
and/or comments (blank lines and comments are ignored).


# Example

For example:
````
$ echo '8d255 "h\"i" 8d-1 "l\\o" 16d1 !endian=0 16d2 !endian=1 16xf 0x123456' | ./mkbin.pl >x
$ hexdump -C x
00000000  ff 68 22 69 ff 6c 5c 6f  00 01 02 00 00 0f 12 34  |.h"i.l\o.......4|
00000010  56                                                |V|
00000011
````

Here's what the commands mean:
* 8d255 - 8-bit decimal value 255
* "h\\"i" - the string h"i (backslash escapes the quote)
* 8d-1 - 8-bit decimal value -1
* "l\\\\o" - the string l\o (backslash escapes the backslash)
* 16d1 - 16-bit decimal value 1 (defaults to big endian)
* !endian=0 - switch to little endian
* 16d2 - 16-bit decimal value 2 in little endian
* !endian=1 - switch to big endian
* 16xf - 16-bit decimal value 15 in big endian
* 0x123456 - three bytes, specified in hex


# TODO

* Include directive
* Simple looping construct
* Variables, functions, if/then/else, for/while, macros, etc, etc.
* Or, if you have a complex data generation that needs language features, just write it in Perl. :-)


# License

I want there to be NO barriers to using this code, so I am releasing it to the public domain.  But "public domain" does not have an internationally agreed upon definition, so I use CC0:

This work is dedicated to the public domain under CC0 1.0 Universal:
http://creativecommons.org/publicdomain/zero/1.0/

To the extent possible under law, Steven Ford has waived all copyright
and related or neighboring rights to this work. In other words, you can 
use this code for any purpose without any restrictions.
This work is published from: United States.
Project home: https://github.com/fordsfords/mkbin
