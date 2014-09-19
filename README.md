# BrickBot: A BrickPi library for Ruby

ruby wrappers for the BrickPi Lego Mindstorms C library

## What you need:

You need to have a few things to use this:

 - The wonderful [BrickPi](http://www.dexterindustries.com/BrickPi.html) from Dexter Industries
 - A Raspberry Pi (if you didn't get one with the BrickPi)
 - Lego Mindstorms NXT 2.0 motors and/or sensors

## Installation

**Note: This gem will currently only install on a Raspberry Pi set up with BrickPi software.** It relies on the `WiringPi.h` C program to function and compile.

You'll first need Ruby installed on your Raspberry Pi. If you need help, this Stack Overflow answer may be of service:
http://raspberrypi.stackexchange.com/questions/1010/can-i-install-the-ruby-version-manager

Add this line to your application's Gemfile:

    gem 'brick-pi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install brick-pi

## Usage

### Motors

Currently, you only get a set of primitives to run motors. Expect a more robust library supporting various configurations (e.g. 2-tracked vehicle) later on.

The Bot object starts and stops the robot. It contains 4 Motor objects, mapped to port A-D on your BrickPi.

Here's a quick & dirty script to spin a motor:

```ruby
require 'brick_pi'

# Create a bot with a motor on port A
class HelloBot < BrickPi::Bot
  motor :port_A

  # Declare a property to adjust speed at any time
  property :motor_speed do |value|
    # This `motor :port_A` to `@motor_A` mapping is yucky, sorry bout that
    @motor_A.spin value
  end
end

# Get this party started
bot = HelloBot.new
bot.motor_speed = 80
bot.start
sleep 2
bot.motor_speed - -80
sleep 2
bot.stop
```

Once your bot is started, you can change the speed or direction of the motors at any time.

Here's a custom bot class and quick script to let you drive a 2-tracked vehicle with an iCade 8-Bitty (which is basically a bluetooth keyboard that looks like an NES controller).

It requires the Highline gem, so on the BrickPi you'll need to run `gem install highline`.

```ruby
require "brick_pi"
require "highline/system_extensions"
include HighLine::SystemExtensions
HighLine::SystemExtensions.raw_no_echo_mode

# Create a bot with two motors
class DemoBot < BrickPi::Bot
  attr_accessor :speed
  motor :port_A
  motor :port_B
  ultrasonic_sensor :port_3

  # A property is always settable and gettable, even while things are running.
  property :forward_speed do |value|
    @motor_A.spin value
    @motor_B.spin value
  end

  # Properties are applied in order. Since it comes second, this trumps forward_speed.
  property :rotation_speed do |value|
    @motor_A.spin -1 * value
    @motor_B.spin value
  end

  def turn_left
    self.rotation_speed = -1 * speed
  end

  def turn_right
    self.rotation_speed = speed
  end

  def move_forward
    # Since rotation speed trumps forward speed, you need to EXTERMINATE it.
    self.rotation_speed = nil
    self.forward_speed = speed
  end

  def move_backward
    self.rotation_speed = nil
    self.forward_speed = -1 * speed
  end

  def increase_speed
    if speed >=0 && speed <= 80
      self.speed += 20
    end
  end

  def decrease_speed
    if speed > 20 && speed <= 100
      self.speed -= 20
    end
  end

  def stop_motors
    self.rotation_speed = nil
    self.forward_speed = 0
  end

end

@bot = DemoBot.new
@bot.start
@bot.speed = 60
puts "bot ready!"

loop do
  unless @bot.sensor_3.distance == 0
    print "SENSOR DISTANCE: "
    puts @bot.sensor_3.distance
  end
  char = HighLine::SystemExtensions.get_character
  case char.chr
  when 'w'
    @bot.move_forward
  when 'd'
    @bot.turn_left
  when 'a'
    @bot.turn_right
  when 'x'
    @bot.move_backward
  when 'o'
    @bot.increase_speed
  when 'l'
    @bot.decrease_speed
  when 'e', 'c', 'z', 'q'
    @bot.stop_motors
  end
end
```

### Sensors

You can read values from sensors by doing something like this:

```
class SensorBot = BrickPi::Bot
  touch_sensor :port_1
end

bot = DemoBot.new
bot.sensor_1.read
```

See the scripts in the `examples` directory for more details.


## Contributing

1. Fork it ( https://github.com/tehviking/brick_pi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Issues

I use HuBoard to manage GitHub issues. It's pretty awesome, check it out here:

https://huboard.com/tehviking/brick_pi_ruby/
