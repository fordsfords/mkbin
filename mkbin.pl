#!/usr/bin/env perl
# mkbin.pl

# This work is dedicated to the public domain under CC0 1.0 Universal:
# http://creativecommons.org/publicdomain/zero/1.0/
# 
# To the extent possible under law, Steven Ford has waived all copyright
# and related or neighboring rights to this work. In other words, you can 
# use this code for any purpose without any restrictions.
# This work is published from: United States.
# Project home: https://github.com/fordsfords/mkbin

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

my %parameters;
$parameters{"endian"} = 1;  # Big endian; a.k.a. network order.

# Main loop; read each line in each file.
while (<>) {
  chomp;  # remove trailing \n
  # Remove comments, leading whitespace, trailing whitespace.
  s/#.*$//; s/^\s*//;  s/\s*$//;
  if (/^$/) {
    # blank lines; ignore.
  }
  else { 
    my $err_msg = parse_line($_, $out_fd);
    if ($err_msg ne "") {
      print STDERR "Error, $err_msg\nInput line: '$_'\n"; exit(1);
    }
  }

} continue {  # This continue clause makes "$." give line number within file.
  close ARGV if eof;
}

close($out_fd);

# All done.
exit(0);


# End of main program, start subroutines.


sub parse_line {
  my ($iline, $fd) = @_;

  while (length($iline) > 0) {
    if ($iline =~ /^([0-9!]\S+)(.*)$/) {
      my $command = $1;
      $iline = $2;  # Remove integer construct from input line.
      $iline =~ s/^\s*//;  # Remove leading whitespace.
      my $err_msg = do_command($command, $fd);
      if ($err_msg ne "") { return $err_msg; }
    }
    elsif ($iline =~ /^"/) {  # Ascii
      my @iline_chars = split(//, $iline);
      my $istring = "";  shift(@iline_chars);  # get rid of leading double quote.
      my $state = "in_string";

      while ($state ne "done") {
        if (scalar(@iline_chars) == 0) {
          return "unterminated string";
        }
        my $c = shift(@iline_chars);
        if ($state eq "escape") {  # Previous char was backslash.
          $istring .= $c;            # add it as regular character.
          $state = "in_string";
        }
        # For rest of tests, state must be "in_string".
        elsif ($c eq '\\') {  # Backslash; escape next character.
          $state = "escape";
        }
        elsif ($c eq '"') {  # End of string
          $state = "done";
        }
        else {  # Just a regular character.
          $istring .= $c;
        }
      }  # while state

      write_string($istring, $fd);
      $iline = join("", @iline_chars);  # Remove string construct from input line.
      $iline =~ s/^\s*//;  # Remove leading whitespace.
    }
    else {
      return "parse_line: unrecognized command at '$iline'";
    }
  }  # while iline
}  # parse_line


sub do_command {
  my ($cmd, $fd) = @_;

  my $err_msg = "";  # Assume success.

  if ($cmd =~ /^!(\w+)\s*=\s*(.+)$/) {
    if (! defined($parameters{$1})) {
      return "parameter '$1' not defined";
    }
    $parameters{$1} = $2;
  }
  elsif ($cmd =~ /^(\d+)d(-*\d+)$/) {
    $err_msg = write_int($1, $2, $fd);
  }
  elsif ($cmd =~ /^0x([\da-fA-F]+)$/) {
    $err_msg = write_arbitrary_hex($1, $fd);
  }
  elsif ($cmd =~ /^(\d+)x([\da-fA-F]+)$/) {
    $err_msg = write_int($1, hex($2), $fd);
  }
  else {
    return "do_command: unrecognized command '$_'";
  }

  return $err_msg;
}  # do_command


sub write_string {
  my ($str, $fd) = @_;

  my $out_str = pack("a*", $str);
  print $fd $out_str;

  return "";
}  # write_string


sub write_arbitrary_hex {
  my ($val, $fd) = @_;

  if ((length($val) % 2) != 0) {
    return "Odd number of hex digits in '$val'";
  }

  my $out_str = pack("H*", $val);
  print $fd $out_str;

  return "";
}  # write_arbitrary_hex


sub write_int {
  my ($size, $val, $fd) = @_;

  my $endian = "<";
  if ($parameters{"endian"}) {
    $endian = ">";
  }

  my $out_str;
  if ($size == 8) {
    if ($val < 0) {
      $out_str = pack("c", $val)
    } else {
      $out_str = pack("C", $val)
    }
  }
  elsif ($size == 16) {
    if ($val < 0) {
      $out_str = pack("s$endian", $val)
    } else {
      $out_str = pack("S$endian", $val)
    }
  }
  elsif ($size == 32) {
    if ($val < 0) {
      $out_str = pack("l$endian", $val)
    } else {
      $out_str = pack("L$endian", $val)
    }
  }
  elsif ($size == 64) {
    if ($val < 0) {
      $out_str = pack("q$endian", $val)
    } else {
      $out_str = pack("Q$endian", $val)
    }
  }
  else {
    return "Bad size '$size'";
  }

  print $fd $out_str;

  return "";
}  # write_int


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
__EOF__

  exit(0);
}  # help
