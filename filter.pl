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
my $pattern_length = qr/\<\<\n\/Length \d+\n\/LC \/QQAP\n\>\>\n/;
my $length_divider = "stream\nendstream\n";
my @lengths        = null;

while (my $line = <FH_IN>) {
  if ($buffer){
    $buffer = $buffer . $line;

    if ($line =~ m/$pattern_end/){

      if ($buffer =~ m/$pattern_filter/ ){
        if(@lengths = $buffer =~ /$pattern_length/gm){
          $buffer_stub = $buffer_stub . join($length_divider, @lengths) . $length_divider;
        }

        $buffer_stub = $buffer_stub . $line;

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
      $buffer_stub = $line;
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
