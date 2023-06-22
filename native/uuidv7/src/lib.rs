use rustler::{Binary, OwnedBinary};
// use uuid::{NoContext, Timestamp, Uuid};
use uuid::Uuid;

#[rustler::nif]
fn add(a: i64, b: i64) -> i64 {
    a + b
}

#[rustler::nif]
fn generate() -> OwnedBinary {
    // let ts: u64 = 1645557742000;

    // let seconds = ts / 1000;
    // let nanos = ((ts % 1000) * 1_000_000) as u32;

    // let uuid = Uuid::new_v7(Timestamp::from_unix(NoContext, seconds, nanos));

    let uuid = Uuid::now_v7();
    let bytes = uuid.to_bytes_le();
    let mut binary = OwnedBinary::new(bytes.len()).unwrap();

    println!("{:?}", bytes);
    println!("{:?}", uuid.to_string());

    binary.as_mut_slice().copy_from_slice(&bytes);

    return binary;
    // pub struct Binary<'a> // size = 32 (0x20), align = 0x8
}

#[rustler::nif]
fn load(uuid: Binary) -> String {
    println!("{:?}", uuid.as_slice());

    let string = Uuid::from_slice(uuid.as_slice()).unwrap().to_string();

    return string;
}

// #[rustler::nif]
// pub fn decode(b64: Binary) -> OwnedBinary {
//     let bytes = base64::decode(b64.as_slice()).expect("decode failed: invalid base64");
//     let mut binary: OwnedBinary = OwnedBinary::new(bytes.len()).unwrap();
//     binary.as_mut_slice().copy_from_slice(&bytes);

//     return binary;
// }

rustler::init!("Elixir.UUIDv7", [add, generate, load]);
