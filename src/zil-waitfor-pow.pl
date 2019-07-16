#!/usr/bin/perl

use LWP::Simple;
use JSON;

# Initialize basics

my $url = 'https://api.zilliqa.com/';
my $json = '{"id": "1", "jsonrpc": "2.0",
    "method": "GetBlockchainInfo",
    "params": [""]
}';

my $req = HTTP::Request->new('POST', $url);
$req->content_type('application/json');
$req->content($json);

my $currentBlock = "unknown yet";
my $powToGo = int(rand(100));
my $sleep = rand(60);
my $loop = 1;

while ($loop) {

  # Fetch blockchain info

  my $ua = LWP::UserAgent->new;
  $ua->agent("zilMinerSwitch/0." . 100-int($powToGo) . " (ethOS)");
  $ua->timeout(10);
  my $res = $ua->request($req);

  if ($res->is_error) {
    print "ERROR $res->code: reading Zilliqa API ($res->message)\n";
    $sleep = $sleep * 0.7 - 0.1;
  }
  else { # Decode result
    my $json = $res->decoded_content . "\n";
    my $obj = from_json($json);
    $currentBlock = $obj->{'result'}->{'NumTxBlocks'};
    $powToGo = int($currentBlock/100)*100+99 - $currentBlock;
    $sleep = $powToGo * (rand(30)+50)/100 - 0.1;
  }

  print localtime(time) . ": ZIL $currentBlock / PoW $powToGo / " . int($sleep) . " mins \n";

  if ( ($powToGo <= 1) or ($sleep < 0.3) ) {
    $sleep = 0;
    $loop = 0;
    break;
  }

  my $wait = $sleep * 60;
  sleep $wait;

}

