use {
    bincode,
    solana_rpc_client_api::response::RpcBlockUpdate,
    std::{
        fs::File,
        io::{Read, Write},
        thread,
        time::Duration,
    },
};

pub fn main() {
    let index = 74;
    let mut file = File::open(format!("data/blocks/serialized_data_{}.bin", index)).unwrap();

    let mut buf = vec![];
    file.read_to_end(&mut buf).unwrap();

    let block = bincode::deserialize::<RpcBlockUpdate>(&buf).unwrap();
    println!("{:?}", block);
}
