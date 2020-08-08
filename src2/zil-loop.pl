#!/usr/bin/perl

use LWP::Simple;
use JSON;
#use strict;
#use warnings;

# Initialize Constants

my $url = 'https://api.zilliqa.com/';
my $json = '{"id": "1", "jsonrpc": "2.0",
    "method": "GetBlockchainInfo",
    "params": [""]
}';

my $req = HTTP::Request->new('POST', $url);
$req->content_type('application/json');
$req->content($json);

my $logfile = "/tmp/zil-switch.log";

# Initialize Variables

my $currentBlock = "unknown yet";
my $txBlockRate = 0.014;
my $powToGo = int(rand(100));
my $sleep;

# Main endless Loop

while (1) {

  $sleep = rand(60);

  &waitForPoW();
  &switchMinerForZil();
  &waitForEndOfPoW();
  &revertMiner();

}


# Functions or Procedures

sub waitForPoW {
  my $loop = 1;
  my $otxBlockRate;

  while ($loop) {

    # Fetch blockchain info
    my $ua = LWP::UserAgent->new;
    $ua->agent("zilMinerSwitch/0." . (100-int($powToGo)) . " (ethOS)");
    $ua->timeout(10);
    my $res = $ua->request($req);

    if ($res->is_error) {
      &log("ERROR $res->code: reading Zilliqa API ($res->message)");
      $sleep = $sleep * 0.8 - 0.1;
      $currentBlock = "unknown";
    }
    else { # Decode result
      my $json = $res->decoded_content . "\n";
      my $obj = from_json($json);
      $currentBlock = $obj->{'result'}->{'NumTxBlocks'};
      $otxBlockRate = $obj->{'result'}->{'TxBlockRate'};
      # adjustment of block rate for the normal 99 blocks,
      # as block 100 takes ~3 minutes:
      $txBlockRate = 1 / ( (1/$otxBlockRate*100 - (2*60+1/$otxBlockRate)) / 99 );
      $powToGo = int($currentBlock/100)*100+99 - $currentBlock;
      $sleep = (($powToGo-1) / $txBlockRate) / 60 * (rand(20)+50)/100 - 0.1;
    }

    &log("INFO: ZIL $currentBlock / PoW -$powToGo / $otxBlockRate ($txBlockRate) / " . (int($sleep)) . " mins");

    if ( ($powToGo <= 1) or ($sleep < 0.3) ) {
      $sleep = 0;
      $loop = 0;
      last;
    }

    my $wait = $sleep * 60;
    sleep $wait;

  }
}


sub waitForEndOfPoW {
  my $loop = 1;
  my $starttime = time;
  $sleep = 60 + (1 / $txBlockRate);
  
  while ($loop) {
    sleep $sleep;

    # Fetch blockchain info
    my $ua = LWP::UserAgent->new;
    $ua->agent("zilMinerSwitch/1." . (100+$loop) . " (ethOS)");
    $ua->timeout(10);
    my $res = $ua->request($req);

    if ($res->is_error) {
      &log("ERROR $res->code: reading Zilliqa API ($res->message)");
      $sleep = $sleep * 0.8 - 0.1;
      $currentBlock = "unknown";
    }
    else { # Decode result
      my $json = $res->decoded_content . "\n";
      my $obj = from_json($json);
      $currentBlock = $obj->{'result'}->{'NumTxBlocks'};
      $txBlockRate = $obj->{'result'}->{'TxBlockRate'};
      $powToGo = int($currentBlock/100)*100+99 - $currentBlock;
      $sleep = (1 / $txBlockRate) - rand(10 + $loop++);
    }

    &log("NOTICE: MINING ZIL $currentBlock ($txBlockRate) / " . (int($sleep)) . " secs");

    # if ZIL TxBlock Height indicates that PoW is over
    if ( ($powToGo < 99) and ($powToGo > 2 ) ) {
      $loop = 0;
      last;
    }

    # if 6 minutes have passed
    if ( time > ( $starttime + 6*60 ) ) {
      &log("INFO: on ZIL PoW for too long");
      $loop = 0;
      last;
    }

  }
}


sub switchMinerForZil {
  system("mv /home/ethos/remote.conf /home/ethos/remote.conf.zilswitch.orig");
  system("echo '# local ZIL config only' > /home/ethos/remote.conf");
  system("cp -p /home/ethos/local.conf /home/ethos/local.conf.zilswitch.orig");
  system("cp /home/ethos/local-zil.conf /home/ethos/local.conf");
  system("/opt/ethos/bin/minestop");
  &log("NOTICE: switch Miner to ZIL mining");
}


sub revertMiner {
  if (-e '/home/ethos/local-ethos.conf') {
    system("cp -p /home/ethos/local-ethos.conf /home/ethos/local.conf");
  } else {
    system("cp -p /home/ethos/local.conf.zilswitch.orig /home/ethos/local.conf");
  }
  if (-e '/home/ethos/remote-ethos.conf') {
    system("cp -p /home/ethos/remote-ethos.conf /home/ethos/remote.conf");
  } else {
    system("cp -p /home/ethos/remote.conf.zilswitch.orig /home/ethos/remote.conf");
  }
  system("/opt/ethos/bin/minestop");
  &log("INFO: switch Miner to ORIG primary mining");
}


sub log {
  my ($t) = @_;
  $t = localtime(time) . ": " . $t;
  eval {
    open LOGFILE,">>$logfile" or die "Can't open logfile $logfile: $!";
    my @l = qw/*STDOUT LOGFILE/;
    for (@l) {
      print $_ "$t\n" or die "Can't write LOG: $!";
    }
    close LOGFILE;
  }
  or do {
    my $error = $@ || 'Unknown failure';
    print "ERROR: ${error}";
    sleep 120;
    #die "ERROR: $!";
  }
}

