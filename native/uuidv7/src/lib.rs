use uuid::{NoContext, Timestamp, Uuid};

#[rustler::nif]
fn generate() -> String {
    Uuid::now_v7().to_string()
}

#[rustler::nif]
fn generate_from_ms(millis: u64) -> String {
    let seconds = millis / 1000;
    let nanos = ((millis % 1000) * 1_000_000) as u32;

    Uuid::new_v7(Timestamp::from_unix(NoContext, seconds, nanos)).to_string()
}

rustler::init!("Elixir.UUIDv7", [generate, generate_from_ms]);
