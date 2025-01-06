#!/bin/bash

echo "Installing dependencies..."
npm install

echo "Starting CryptoTracker..."
node index.js -c BTC,ETH
