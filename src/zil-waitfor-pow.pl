#!/usr/bin/perl

use LWP::Simple;
use JSON;

my $currentBlock = "unknown yet";
my $powToGo = int(rand(100));
my $sleep = rand(60);
my $loop = 1;

while ($loop) {

  # Fetch blockchain info


  if ($sleep>=60) {
    print "ERROR: Loop just started.\n";
    $sleep = $sleep / 2 - 0.1;
  }
  else {

    # Decode result


    $currentBlock = "unknown yet";
    $powToGo = int(rand(100));

    $sleep = $powToGo * (rand(20)+50)/100 - 0.1;

  }

  print localtime(time) . ": ZIL $currentBlock / PoW $powToGo / " . int($sleep) . " mins \n";

  if ($powToGo <= 1) {
    $sleep = 0;
    $loop = 0;
    break;
  }

  if ($sleep <= 3) {
    $sleep = $sleep * (rand(20)+50)/100;
  }

  my $wait = $sleep * 60;
  sleep $wait;

}

