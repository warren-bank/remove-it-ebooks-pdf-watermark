#!/usr/bin/perl

$/ = "\n";
$\ = "";
$, = "";

open(FH_IN,  "<in.pdf");
open(FH_OUT, ">out.pdf");
binmode(FH_IN);
binmode(FH_OUT);

my $buffer         = '';
my $buffer_stub    = '';
my $pattern_start  = qr/^\d+\s+\d+\s+obj/;
my $pattern_end    = qr/endobj\b/;
my $pattern_filter = qr/\((?:www\.it-ebooks\.info|http:\/\/www\.it-ebooks\.info\/)\)/;

while (my $line = <FH_IN>) {
  if ($buffer){
    $buffer = $buffer . $line;

    if ($line =~ m/$pattern_end/){
      $buffer_stub = $buffer_stub . $line;

      if ($buffer =~ m/$pattern_filter/ ){
        print FH_OUT $buffer_stub;
      }
      else {
        print FH_OUT $buffer;
      }

      $buffer      = '';
      $buffer_stub = '';
    }
  }

  else {

    if ( $line =~ m/$pattern_start/ ){
      $buffer      = $line;
      $buffer_stub = $line . "<<\n/Length 0\n/LC /QQAP\n>>\nstream\n\nendstream\n";
    } else {
      print FH_OUT $line;
    }

  }

}

if ($buffer){
  print FH_OUT $buffer;
  $buffer = '';
}

close (FH_IN);
close (FH_OUT);
