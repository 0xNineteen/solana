#!/bin/bash

cargo build 

ledger_dir=ledger
n_nodes="${1:-2}"
base_port=8000
declare -a processes=()
echo setting up $n_nodes nodes ...

# generate keypairs of all validators first
for ((i=1; i<=n_nodes; i++)); do
    node_ledger_dir=$ledger_dir/node${i}
    # custom reset logic to have same genesis files 
    rm -rf $node_ledger_dir
    # reset
    mkdir -p $node_ledger_dir

    # create validator keypairs
    solana-keygen new --no-passphrase -sfo $node_ledger_dir/validator_id.json 
    solana-keygen new --no-passphrase -sfo $node_ledger_dir/validator_vote.json 
    solana-keygen new --no-passphrase -sfo $node_ledger_dir/validator_stake.json 
done

# Start the nodes in the background
for ((i=1; i<=n_nodes; i++)); do
    port=$((base_port + (i - 1) * 10))

    # start the local node
    echo starting node${i} with gossip port $port \; rpc port on $((port+2))...
    node_ledger_dir=$ledger_dir/node${i}

    # note cluster-size arg
    ../target/debug/solana-test-validator \
        -q \
        --bind-address 127.0.0.1 \
        --gossip-port $port \
        --slots-per-epoch 100 \
        --faucet-port $((port+1)) \
        --rpc-port $((port+2)) \
        --cluster-size $n_nodes \
        --rpc-pubsub-enable-block-subscription \
        --rpc-pubsub-enable-vote-subscription \
        --ledger $node_ledger_dir &

    # record PID to kill later
    processes[$i-1]=$!
done

sleep 5 # wait for node to start up

# generate random keypairs with SOL 
echo airdroping random keys ...
solana config set --url http://127.0.0.1:$((base_port + 2))
solana config get
n_randos=5 
rando_path=$ledger_dir/rando_keys/
for ((i=1; i<=n_randos; i++)); do
    solana-keygen new --no-passphrase -so $rando_path/${i}.json
    solana airdrop 100 $(solana-keygen pubkey $rando_path/${i}.json)
done

# Wait for Ctrl+C
trap "echo 'Stopping nodes...'; kill ${processes[*]}; exit" SIGINT

# Keep the script running until Ctrl+C is received
echo cluster running...
while true; do
    sleep 1
done
