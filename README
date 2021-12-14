# SmartLamp

SmartLamp example project used for Queen Creek Elixir meetup.

This project is setup in a "poncho project" fashion.

This means all our projects are self contained and can run independently of Nerves.

## What is the responsibilities for each project

1. SmartLampFW - the firmware project that packages your other projects to run on
   a nerves system (our chosen targets are rpi3 and rpi0)
1. SmartLamp - this is core library that contains the business logic of our
   program - this can be considered your "application"
1. SmartLampUi - this is the user interface to your application

## How each project was generated

### SmartLampFW

```bash
mix nerves.new smart_lamp_fw
```

### SmartLamp

```bash
mix new SmartLamp
```

### SmartLampUi

```bash
mix phx.new smart_lamp_ui --no-ecto --no-mailer
```
