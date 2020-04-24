# crypto-zil-miner-switch-ethos
Zilliqa (ZIL) Mining Switch for ethOS

## Background

[Zilliqa](https://github.com/Zilliqa/Zilliqa) (ZIL) is a blockchain with a
very specific mining process. Mining on the
[Ethash](https://github.com/ethereum/wiki/wiki/Ethash)
algorithm for only less than 5 minutes roughly each 2.5 hours allows the
owner of the ethOS rig to mine their other preferred coins throughout
the rest of the time.

### Description

This little set of scripts makes sure your rig monitors the proof-of-work
(PoW) start time, and when required stops your main miner, fires up the
ZIL miner, and switches back to your main miner afterwards.

We're not utilizing the 'native' Zilliqa mining setup here. Instead a
mining pool will be used for simplicity.

In the background a script checks the block height of the ZIL blockchain
every this and then in a loop by calling the Zilliqa API in a decreasing
interval. Once the block 99 is hit, the background sleep stops, the main
miner is disallowed and the mining for ZIL starts for 5 minutes. After
this period the ZIL miner terminates automatically, the main miner is
launched again, and the loop starts from the beginning.

## Getting Started

In this version some manual tasks for the configuration is still required.
If you follow the instructions carefully you shall have your ZIL mining up
and running within just a few minutes.

### Prerequisites

You need to be running a mining rig with [ethOS](http://ethosdistro.com) 1.3.3
installed.

You need to own a wallet address for ZIL.

### Installation

Run the following commands in your ethOS shell:

```
bash <(curl -s https://raw.githubusercontent.com/71ae/crypto-zil-miner-switch-ethos/v1.3/install-zil.sh)
```

### Configuration

After the installation please edit the pool and wallet configuration!
```
nano zil-miner-switch/minerpool.txt
```

After you've done this, you can start this toolsuite with:
```
bash zil-miner-switch/zil-init.sh
```

To make sure the ZIL Mining Switcher also starts when you power on your rig,
you also can add the following line into custom.sh (execute `nano custom.sh`)
before the "exit" line:
```
bash -c zil-miner-switch/zil-init.sh
```

### Upgrading

If you already have this ZIL Mining Switch tool installed before,
it's recommended to make a backup of the config files `minerpool.txt`
and `mineropts.txt` before upgrading. The installer tries to keep them
untouched, though.

Some upgrades may come with changes in the mineropts. To make sure to
use the latest options you may want to remove the file (after you've
taken a backup):
```
rm zil-miner-switch/mineropts.txt
```

For upgrading just run the installer command again.
```
bash <(curl -s https://raw.githubusercontent.com/71ae/crypto-zil-miner-switch-ethos/v1.3/install-zil.sh)
```

### Verification

To verify that this toolsuite is running, you can fire this command:
```
pgrep -fl zil
```
The output should show exactly these three commands (the numbers in front
are irrelevant):
```
3415 screen
3419 zil-loop.sh
18251 perl
```

Further more, to keep an eye on what these scripts actually are doing,
we're writing a tiny log file that you can tail with this command
(exit with `Ctrl-c`):
```
tail -f /tmp/zil-switch.log
```

If you are an experienced user, you may enter into the background screen:
```
screen -r zil
```
Make sure to exit this screen with `Ctrl-a d`. Do not keep it open for
longer than necessary, and do NOT do a `Ctrl-c` here as this likely would
stop the switcher.

### Farms

You are limited to installing 15 miners an hour as this script makes
4 GitHub calls per install. Use authenticated requests if you require more.

## Utilization

For running this script we're making use of the following components:

* Bash, Perl, and curl
* [Miner Manager for ethOS](https://github.com/cynixx3/third-party-miner-installer-for-ethos)
* [PhoenixMiner](https://phoenix-miner.github.io)
* libwww-perl (LWP)
* JSON for perl

The installation script makes sure that these tools are installed, if
they aren't part of ethOS yet.

## Author

* [@71ae](https://github.com/71ae) - Andreas E.

If you find this helpful, a small donation always is welcome
(every coin helps):

- BTC 1Q1Hnm26TY3nf5NCxTcEJKMYq3C1ejTXCZ
- ETH 0x18eb62e93adceb68c8b28c7e0f6e168ad76500bc (ETH only, no ERC20 tokens)
- LTC LXNgnAodqT5HYBVqKpxdPKCdYFNRphMzg6
- ETC 0x502a5609fa5e0c1a991fbcc595a48385a764cd16
- ZEC t1XANY6JV8asAAUegv6v4S2bQE6SzAumkVQ
- ZIL zil19pa7mefxhal7jeda0p6agft5cxc97gfcnl55e0

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE)
file for details.

