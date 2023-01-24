# mkbin.pl
Perl-based binary data generator.

# Exmples

````
!endian=1 # Set big-endian.
"abc"     # C-style string with trailing NULL.
'xyz'     # ascii characters (no trailing NULL).
0x123456  # "0x" means hex sequence of bytes, NOT endian encoded.
32xffff   # Hex value for 32-bit integer encoded per endian.
16b1111111100000000 # Binary value for 16-bit integer encoded per endian.
16d1,520  # Decimal value for 16-bit integer (commas ignored).
# Looping construct.
< < 'a' >3 0x00 >2  # Same as "aaa" "aaa".
#include "header.mkbin"     # Include the file.
````

# License

I want there to be NO barriers to using this code, so I am releasing it to the public domain.  But "public domain" does not have an internationally agreed upon definition, so I use CC0:

Copyright 2020 Steven Ford http://geeky-boy.com and licensed
"public domain" style under
[CC0](http://creativecommons.org/publicdomain/zero/1.0/):
![CC0](https://licensebuttons.net/p/zero/1.0/88x31.png "CC0")

To the extent possible under law, the contributors to this project have
waived all copyright and related or neighboring rights to this work.
In other words, you can use this code for any purpose without any
restrictions.  This work is published from: United States.  The project home
is https://github.com/fordsfords/grep.pl

To contact me, Steve Ford, project owner, you can find my email address
at http://geeky-boy.com.  Can't see it?  Keep looking.
