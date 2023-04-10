// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// Blockhash(Block number - 0xa) & 0xffffff
// Gasprice & 0xffffff

// This challenge requires setting the gasPrice of the transaction to be
// the same value as the last 3 bytes of the blockhash from 10 blocks prior
// since you can't easily dynamically set the gasPrice from within foundry
// the solve script for this is located in the hardhat directory of this repo

// hardhat/scripts/hexp.ts
