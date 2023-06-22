use uuid::Uuid;

#[rustler::nif]
fn add(a: i64, b: i64) -> i64 {
    a + b
}

#[rustler::nif]
fn generate() -> String {
    // Uuid::new_v7().to_string()
    Uuid::new_v4().to_string()
}

rustler::init!("Elixir.UUIDv7", [add, generate]);
