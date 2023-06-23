Benchee.run(
  %{
    "uuidv7" => fn -> UUIDv7.generate() end,
    "uniq (uuid v7)" => fn -> Uniq.UUID.uuid7() end,
    "ecto (uuid v4)" => fn -> Ecto.UUID.generate() end
  },
  warmup: 5,
  time: 10,
  memory_time: 5
)
