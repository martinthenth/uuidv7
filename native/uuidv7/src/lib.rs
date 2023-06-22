use rustler::{Binary, OwnedBinary};
use uuid::{NoContext, Timestamp, Uuid};

#[rustler::nif]
fn bingenerate() -> OwnedBinary {
    to_binary(Uuid::now_v7())
}

#[rustler::nif]
fn bingenerate_from_ns(millis: u64) -> OwnedBinary {
    let seconds = millis / 1000;
    let nanos = ((millis % 1000) * 1_000_000) as u32;

    to_binary(Uuid::new_v7(Timestamp::from_unix(
        NoContext, seconds, nanos,
    )))
}

fn to_binary(uuid: Uuid) -> OwnedBinary {
    let bytes = uuid.to_bytes_le();
    let mut binary = OwnedBinary::new(bytes.len()).unwrap();

    binary.as_mut_slice().copy_from_slice(&bytes);

    return binary;
}

#[rustler::nif]
fn integration(uuid: Binary) -> String {
    Uuid::from_slice(uuid.as_slice()).unwrap().to_string()
}

rustler::init!(
    "Elixir.UUIDv7",
    [bingenerate, bingenerate_from_ns, integration]
);
