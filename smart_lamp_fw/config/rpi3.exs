import Config

config :nerves,
  erlinit: [ctty: "ttyAMA0", tty_options: "115200n8", alternate_exec: "/usr/bin/nbtty"]
