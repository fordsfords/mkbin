#!/usr/bin/env perl
# mkbin.pl.pl
#
# This code and its documentation is Copyright 2023-2023 Steven Ford
# and licensed "public domain" style under Creative Commons "CC0":
#   http://creativecommons.org/publicdomain/zero/1.0/
# To the extent possible under law, the contributors to this project have
# waived all copyright and related or neighboring rights to this work.
# In other words, you can use this code for any purpose without any
# restrictions.  This work is published from: United States.  The project home
# is https://github.com/fordsfords/skeleton

use strict;
use warnings;
use Getopt::Std;
use File::Basename;
use Carp;

# globals
my $tool = basename($0);

# process options.
use vars qw($opt_h $opt_o);
getopts('ho:') || mycroak("getopts failure");

if (defined($opt_h)) {
  help();
}

my $out_fd;
if (defined($opt_o)) {
  open($out_fd, ">", $opt_o) or mycroak("Error opening '$opt_o': $!");
} else {
  $out_fd = *STDOUT;
}
binmode $out_fd;

my $out_string;
$out_string = pack("c", -1);
print $out_fd $out_string;
$out_string = pack("H*", "313233");
print $out_fd $out_string;
$out_string = pack("n", 1);
print $out_fd $out_string;
$out_string = pack("A*", "313233");
print $out_fd $out_string;
$out_string = pack("N", 1);
print $out_fd $out_string;
$out_string = pack("v", 1);
print $out_fd $out_string;
$out_string = pack("V", 1);
print $out_fd $out_string;

exit(0);

# Main loop; read each line in each file.
while (<>) {
  chomp;  # remove trailing \n

  $out_string = pack("H*", $_);
  print $out_fd $out_string;
} continue {  # This continue clause makes "$." give line number within file.
  close ARGV if eof;
}

close($out_fd);

# All done.
exit(0);


# End of main program, start subroutines.


sub mycroak {
  my ($msg) = @_;

  if (defined($ARGV)) {
    # Print input file name and line number.
    croak("Error (use -h for help): input_file:line=$ARGV:$., $msg");
  } else {
    croak("Error (use -h for help): $msg");
  }
}  # mycroak


sub assrt {
  my ($assertion, $msg) = @_;

  if (! ($assertion)) {
    if (defined($msg)) {
      mycroak("Assertion failed, $msg");
    } else {
      mycroak("Assertion failed");
    }
  }
}  # assrt


sub help {
  my($err_str) = @_;

  if (defined $err_str) {
    print "$tool: $err_str\n\n";
  }
  print <<__EOF__;
Usage: $tool [-h] [-o out_file] [file ...]
Where ('R' indicates required option):
    -h - help
    -o out_file - output file (default: STDOUT).
    file ... - zero or more input files.  If omitted, inputs from stdin.

__EOF__

  exit(0);
}  # help
