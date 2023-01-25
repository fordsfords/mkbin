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

hexdump -x x >x.hex

cat >x.tst <<__EOF__
0000000    68ff    6922    6c01    ff6f    0302    ff00    2268    0069
0000010    6c01    ff6f    02ff    0000    0003    0000    68ff    6922
0000020    0000    0100    6f6c    ffff    ffff    0002    0000    0000
0000030    0300    0000    0000    0000    ff00    2268    0069    0000
0000040    0000    0000    6c01    ff6f    ffff    ffff    ffff    02ff
0000050    0000    0000    0000    0000    0000    0000    0000    ab03
0000060    efcd    3412    7856    0090                                
0000067
__EOF__

if diff x.hex x.tst; then :
  echo OK
else :
  echo FAIL
fi
