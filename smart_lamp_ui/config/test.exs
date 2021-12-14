import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :smart_lamp_ui, SmartLampUiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "iHFZXzNIfktN5v2mQ4BYzg3kMFPtQ96UwzKiHRZvee43dV2qDAB9+9pLwucMsNwl",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
