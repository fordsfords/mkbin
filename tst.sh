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


./mkbin.pl >x; hexdump -C x
