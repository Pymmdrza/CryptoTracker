# Crypto Tracker CLI

![Crypto Tracker CLI](https://raw.githubusercontent.com/Pymmdrza/CryptoTracker/refs/heads/main/.github/CryptoTracker_Header.webp 'Crypto Tracker CLI')

Real-time cryptocurrency price tracking CLI tool with advanced monitoring capabilities and data export features.

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Node](https://img.shields.io/badge/node-%3E%3D16.0.0-green.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

## Features

- Real-time price tracking for multiple cryptocurrencies
- Beautiful CLI interface with color-coded price changes
- Automatic CSV data export for analysis
- Configurable update intervals
- Support for multiple cryptocurrencies
- Low memory footprint

## Quick Start

### Prerequisites

- Node.js >= 16.0.0
- npm >= 8.0.0

### Installation

```bash
git clone https://github.com/Pymmdrza/CryptoTracker.git
cd CryptoTracker
npm install
```

### Usage

Track specific coins:
```bash
node index.js -c BTC,ETH
```

Set custom update interval:
```bash
node index.js -c BTC,ETH -d 60
```

### Options

- `-c, --coins <symbols>`: Comma-separated list of coin symbols (e.g., BTC,ETH)
- `-d, --delay <seconds>`: Update interval in seconds (default: 30)
- `-o, --output <dir>`: Custom output directory for CSV files

## Command Reference

| Command | Description | Example |
|---------|-------------|---------|
| `node index.js -c BTC` | Track single cryptocurrency | Tracks **Bitcoin** only |
| `node index.js -c BTC,ETH,XRP` | Track multiple cryptocurrencies | Tracks **Bitcoin** , **Ethereum**, and **Ripple** |
| `node index.js -c BTC,ETH -d 60` | Custom update interval | Updates every `60` seconds |
| `node index.js -c BTC -o custom_data` | Custom output directory | Saves data to `custom_data` folder |
| `node index.js -c BTC,ETH --help` | Show help menu | Displays all available options |
| `node index.js -v` | Show version | Displays current version |
| `node index.js -c BTC,ETH -d 15` | Fast updates | Updates every `15` seconds |
| `node index.js -c ALL` | Track **all** available coins | Tracks all supported cryptocurrencies |

>[!NOTE]
>Support Coin: [PAIRS](./PAIRS.md)

## Data Export

CSV files are automatically generated in the `dataset` directory with the following format:
```
Symbol,Price,24h High,24h Low,Change %,Timestamp
```

## License

MIT License - see the [LICENSE](LICENSE) file for details


## Programmer & Owner

Credit : [Mmdrza.Com](https://mmdrza.com 'Cryptocurrencie Software and Tools')

Github : [@Pymmdrza](https://github.com/Pymmdrza 'Programmer and Owner : Pymmdrza')

## Donate


