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

od -tx1 x | sed 's/  */ /g; s/ *$//' >x.hex

cat >x.tst <<__EOF__
0000000 ff 68 22 69 01 6c 6f ff 02 03 00 ff 68 22 69 00
0000020 01 6c 6f ff ff 02 00 00 03 00 00 00 ff 68 22 69
0000040 00 00 00 01 6c 6f ff ff ff ff 02 00 00 00 00 00
0000060 00 03 00 00 00 00 00 00 00 ff 68 22 69 00 00 00
0000100 00 00 00 00 01 6c 6f ff ff ff ff ff ff ff ff 02
0000120 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 ab
0000140 cd ef 12 34 56 78 90
0000147
__EOF__

if diff x.hex x.tst; then :
  echo OK
else :
  echo FAIL
fi
