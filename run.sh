#!/usr/bin/env bash
#!/bin/bash

rm solana-rpc.log

export RUST_BACKTRACE=full
./target/debug/solana-validator \
    --dynamic-port-range 11000-11014 \
    --identity ~/Documents/workspace/solana/keys/devnet_wallet.key \
    --entrypoint entrypoint.mainnet-beta.solana.com:8001 \
    --entrypoint entrypoint2.mainnet-beta.solana.com:8001 \
    --entrypoint entrypoint3.mainnet-beta.solana.com:8001 \
    --entrypoint entrypoint4.mainnet-beta.solana.com:8001 \
    --entrypoint entrypoint5.mainnet-beta.solana.com:8001 \
    --expected-genesis-hash 5eykt4UsFv8P8NJdTREpY1vzqKqZKvdpKuc147dw2N9d \
    --ledger ./ledger \
    --rpc-port 8899 \
    --rpc-bind-address 0.0.0.0 \
    --known-validator 7Np41oeYqPefeNQEHSv1UDhYrehxin3NStELsSKCT4K2 \
    --known-validator GdnSyH3YtwcxFvQrVVJMm1JhTS4QVX7MFsX56uJLUfiZ \
    --known-validator DE1bawNcRJB9rVm3buyMVfr8mBEoyyu73NBovf2oXJsJ \
    --known-validator CakcnaRDHka2gXyfbEd2d3xsvkJkqsLw2akB3zsN1D2S \
    --known-validator Frog1Fks1AVN8ywFH3HTFeYojq6LQqoEPzgQFx2Kz5Ch \
    --known-validator 57i31UEyDg4koaZMZ1wAHbYuezXv3AVaHtvJgJarxt3f \
    --expected-shred-version 56177 \
    --accounts ledger/accounts \
    --no-voting \
    --enable-rpc-transaction-history \
    --enable-cpi-and-log-storage \
    --health-check-slot-distance 1500 \
    --maximum-local-snapshot-age 2000 \
    --snapshot-compression none \
    --full-rpc-api \
    --only-known-rpc \
    --wal-recovery-mode skip_any_corrupted_record \
    --log ./solana-rpc.log \
    --no-snapshot-fetch \
    --no-os-cpu-stats-reporting \
    --no-os-memory-stats-reporting \
    --no-os-network-stats-reporting \
    --no-port-check

cat solana-rpc.log | less
