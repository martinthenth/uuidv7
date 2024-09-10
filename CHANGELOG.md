# 1.0.0

- Removes the dependency on Rust, it is now an Elixir-based implementation
  - A test suite was added to ensure the Elixir implementation remains compliant to the RFC
  - RFC: [](https://datatracker.ietf.org/doc/rfc9562/)
- Renames `generate_from_ms/1` to `generate/1`
- Graduates the library to version `1.0.0` 🎉

# 0.2.1

- Add more build targets for the NIFs
- Build NIFs for version 2.16 and 2.17

# 0.2.0

- Renames `generate_from_ns/1` to `generate_from_ms/1`
- Refactors the `Ecto.Type` code into it's own module as a macro

# 0.1.0

- Initial release
