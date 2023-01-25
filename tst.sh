#!/bin/sh
# tst.sh

fail() {
  egrep "^test" tst.tmp
  echo "FAIL at $(caller)"
  exit 1
}

ok() {
  echo "OK: $(egrep '^test' tst.tmp)"
}


./mkbin.pl -o x <<__EOF__
# comment
8d255  "h\"i" 8d1  "\l\\o" 8d-1  !endian=0 8d2  !endian=1 8d3 # comment

16d255 "h\"i" 16d1 "\l\\o" 16d-1 !endian=0 16d2 !endian=1 16d3
32d255 "h\"i" 32d1 "\l\\o" 32d-1 !endian=0 32d2 !endian=1 32d3
64d255 "h\"i" 64d1 "\l\\o" 64d-1 !endian=0 64d2 !endian=1 64d3
0xabcdef1234567890 # hex
__EOF__

hexdump -C x >x.hex
cat >x.tst <<__EOF__
00000000  ff 68 22 69 01 6c 6f ff  02 03 00 ff 68 22 69 00  |.h"i.lo.....h"i.|
00000010  01 6c 6f ff ff 02 00 00  03 00 00 00 ff 68 22 69  |.lo..........h"i|
00000020  00 00 00 01 6c 6f ff ff  ff ff 02 00 00 00 00 00  |....lo..........|
00000030  00 03 00 00 00 00 00 00  00 ff 68 22 69 00 00 00  |..........h"i...|
00000040  00 00 00 00 01 6c 6f ff  ff ff ff ff ff ff ff 02  |.....lo.........|
00000050  00 00 00 00 00 00 00 00  00 00 00 00 00 00 03 ab  |................|
00000060  cd ef 12 34 56 78 90                              |...4Vx.|
00000067
__EOF__

if diff x.hex x.tst; then :
  echo OK
else :
  echo FAIL
fi
