@echo off
echo Installing dependencies...
npm install

echo Starting CryptoTracker...
node index.js -c BTC,ETH

pause
