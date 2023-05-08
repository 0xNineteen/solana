use std::{time::Duration, thread};

use solana_pubsub_client::pubsub_client::PubsubClient;

pub fn main() { 
    let url = "ws://127.0.0.1:8003/";
    let (mut client, recv) = PubsubClient::block_subscribe(
        url, 
        solana_rpc_client_api::config::RpcBlockSubscribeFilter::All, 
        None
    ).unwrap();

    loop { 
        match recv.recv() { 
            Ok(block) => {
                println!("{:?}", block);
            },
            Err(e) => {
                println!("{:?}", e);
            }
        }
        thread::sleep(Duration::from_secs(1));
    }
}