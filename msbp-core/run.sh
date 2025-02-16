#!/bin/bash

# Install the current packages
pnpm i

# Upgrade packages using npm-check-updates, excluding typescript
npx npm-check-updates -u --reject typescript --reject eslint

# Install the updated packages
pnpm install

# Build the Angular website
npx ng build --output-path ../docs

# Move the dist folder one level up
mv -rf dist ../dist

# Serve the Angular website
npx ng serve --host 0.0.0.0
