#!/bin/bash

# Install the current packages
pnpm i

# Upgrade packages using npm-check-updates, excluding typescript
npx npm-check-updates -u --reject typescript

# Install the updated packages
pnpm install

# Build the Angular website
pnpm build

# Serve the Angular website
pnpm start