# crypto-zil-miner-switch-ethos
Zilliqa (ZIL) Mining Switch for ethOS

## Background

[Zilliqa](https://github.com/Zilliqa/Zilliqa) (ZIL) is a blockchain with a
very specific mining process. Mining on the
[Ethash](https://github.com/ethereum/wiki/wiki/Ethash)
algorithm for only less than 5 minutes roughly each 2.5 hours allows the
owner of the ethOS rig to mine their other preferred coins throughout
the rest of the time.

This little set of scripts makes sure your rig monitors the proof-of-work
(PoW) start time, and when required stops your main miner, fires up the
ZIL miner, and switches back to your main miner afterwards.

## Getting Started

These instructions and the scripts are designed for ease of use.
Follow them carefully and you shall have your ZIL mining up and running
within just a few minutes.

### Prerequisites

You need to be running a mining rig with ethOS 1.3.3 installed.

You need to own a wallet address for ZIL.

### Installation


### Configuration


### Farms

You are limited to installing 15 miners an hour as this script makes
4 GitHub calls per install. Use authenticated requests if you require more.

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

