import axios from 'axios';
import chalk from 'chalk';
import Table from 'cli-table3';
import { program } from 'commander';
import ora from 'ora';
import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// Configuration
const OUTPUT_DIR = path.join(__dirname, 'dataset');

// Helper Functions
const getTimer = () => new Date().toISOString().replace(/T/, ' ').replace(/\..+/, '');
const formatFloat = (x, precision = 8) => Number(x).toFixed(precision).replace(/\.?0+$/, '');

async function ensureOutputDir() {
  try {
    await fs.access(OUTPUT_DIR);
  } catch {
    await fs.mkdir(OUTPUT_DIR, { recursive: true });
  }
  
  // Clean up old files
  const files = await fs.readdir(OUTPUT_DIR);
  for (const file of files) {
    await fs.unlink(path.join(OUTPUT_DIR, file));
  }
}

async function getMarketData(coins) {
  try {
    if (coins.length <= 5) {
      // Use individual API calls for better performance with fewer coins
      const promises = coins.map(coin => 
        axios.get(`https://api.kucoin.com/api/v1/market/stats?symbol=${coin}-USDT`)
      );
      const responses = await Promise.all(promises);
      return responses.map(response => ({
        symbol: response.data.data.symbol,
        last: response.data.data.last,
        high: response.data.data.high,
        low: response.data.data.low,
        changeRate: response.data.data.changeRate
      }));
    } else {
      // Use allTickers endpoint for many coins
      const { data } = await axios.get("https://api.kucoin.com/api/v1/market/allTickers");
      return data.data.ticker;
    }
  } catch (error) {
    console.error(chalk.red('Error fetching market data:', error.message));
    return null;
  }
}

function getCoinDetails(coin, tickers) {
  const ticker = Array.isArray(tickers) 
    ? tickers.find(t => t.symbol === `${coin}-USDT`)
    : tickers;
    
  if (!ticker) return null;

  return {
    symbol: `${coin}-USDT`,
    lastPrice: formatFloat(ticker.last),
    highPrice24h: formatFloat(ticker.high),
    lowPrice24h: formatFloat(ticker.low),
    changeRate: formatFloat(ticker.changeRate * 100, 2),
    lastUpdated: getTimer()
  };
}

async function writeToCSV(data, coin) {
  const date = new Date().toISOString().split('T')[0];
  const filename = path.join(OUTPUT_DIR, `${coin}_${date}.csv`);
  const content = `${data.symbol},${data.lastPrice},${data.highPrice24h},${data.lowPrice24h},${data.changeRate},${data.lastUpdated}\n`;

  try {
    await fs.appendFile(filename, content);
  } catch (error) {
    console.error(chalk.red(`Error writing to CSV for ${coin}:`, error.message));
  }
}

async function displayPrices(coins, delay = 30) {
  console.log(chalk.yellow('Press Ctrl+C to stop the tracker\n'));
  
  const spinner = ora('Fetching market data...');
  
  while (true) {
    try {
      spinner.start();
      const tickers = await getMarketData(coins);
      if (!tickers) {
        spinner.fail('Failed to fetch data. Retrying...');
        await new Promise(resolve => setTimeout(resolve, 5000));
        continue;
      }
      
      console.clear();
      
      const table = new Table({
        head: ['Coin', 'Price', 'High (24h)', 'Low (24h)', 'Change %', 'Updated'],
        style: { head: ['cyan'] },
        chars: {
          'top': '─', 'top-mid': '┬', 'top-left': '┌', 'top-right': '┐',
          'bottom': '─', 'bottom-mid': '┴', 'bottom-left': '└', 'bottom-right': '┘',
          'left': '│', 'left-mid': '├', 'mid': '─', 'mid-mid': '┼',
          'right': '│', 'right-mid': '┤', 'middle': '│'
        }
      });

      const selectedCoins = coins.map(coin => coin.toUpperCase());

      for (const coin of selectedCoins) {
        const data = getCoinDetails(coin, tickers);
        if (!data) continue;

        const changeColor = parseFloat(data.changeRate) >= 0 ? chalk.green : chalk.red;
        
        table.push([
          chalk.yellow(data.symbol),
          data.lastPrice,
          chalk.green(data.highPrice24h),
          chalk.red(data.lowPrice24h),
          changeColor(data.changeRate + '%'),
          chalk.gray(data.lastUpdated)
        ]);

        await writeToCSV(data, coin);
      }

      spinner.stop();
      console.log(table.toString());

      // Add countdown timer and optimization message
      console.log(chalk.gray('\nOptimized API calls: Using individual endpoints for better performance'));
      
      for (let remaining = delay; remaining > 0; remaining--) {
        process.stdout.write(`\r${chalk.cyan(`Next update in ${remaining} seconds...`)}`);
        await new Promise(resolve => setTimeout(resolve, 1000));
      }
      process.stdout.write('\r' + ' '.repeat(50) + '\r');
      
      console.log(chalk.gray('\nPress Ctrl+C to stop the tracker'));
      
    } catch (error) {
      spinner.fail(chalk.red('Error:', error.message));
      await new Promise(resolve => setTimeout(resolve, 5000));
    }
  }
}

// CLI Setup
program
  .version('1.0.0')
  .description('Cryptocurrency price tracker with real-time updates')
  .option('-c, --coins <symbols>', 'Comma-separated list of coin symbols (e.g., BTC,ETH,XRP)')
  .option('-d, --delay <seconds>', 'Update delay in seconds', '30')
  .option('-o, --output <dir>', 'Output directory for CSV files', 'dataset')
  .addHelpText('after', `
Examples:
  $ node index.js -c BTC,ETH        # Track only Bitcoin and Ethereum
  $ node index.js -d 60             # Update every 60 seconds
  $ node index.js -o custom_dir     # Custom output directory
  `);

program.parse();

const options = program.opts();

if (!options.coins) {
  console.error(chalk.red('Error: Please specify coins to track using -c or --coins option'));
  console.log('Example: node index.js -c BTC,ETH');
  process.exit(1);
}

const selectedCoins = options.coins.split(',');
const delay = parseInt(options.delay);

// Main execution
await ensureOutputDir();
await displayPrices(selectedCoins, delay);
