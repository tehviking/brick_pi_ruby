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
bot = BrickPi.create do |bot|
  bot.motor :port_A
end

# Get this party started
bot.start do
  schedule do
    # Set the speed for a motor, on a scale of 0 - 100
    bot.motor_A.spin 50

    # Run the motor for 1 second
    sleep 1

    # Stop a single motor
    bot.motor_A.stop
  end
end
```

Once your bot is started, you can change the speed or direction of the motors at any time with the `Motor#spin` method.

Here's a really yucky script I hacked together to let you drive a 2-tracked vehicle with an iCade 8-Bitty (which is basically a bluetooth keyboard that looks like an NES controller).

It requires the Highline gem, so on the BrickPi you'll need to run `gem install highline`.

```ruby
require "brick_pi"
require "highline/system_extensions"
include HighLine::SystemExtensions
HighLine::SystemExtensions.raw_no_echo_mode

# Create a bot with two motors
bot = BrickPi.create do |bot|
  bot.motor :port_A
  bot.motor :port_B
  bot.ultrasonic_sensor :port_3
end

bot.singleton_class.class_eval do
  attr_accessor :speed

  def move_forward
    schedule do |op|
      motor_A.spin speed
      motor_B.spin speed
    end
  end

  def move_backward
    schedule do
      motor_A.spin 0 - speed
      motor_B.spin 0 - speed
    end
  end

  def turn_left
    schedule do
      motor_A.spin speed
      motor_B.spin 0 - speed
    end
  end

  def turn_right
    schedule do
      motor_A.spin 0 - speed
      motor_B.spin speed
    end
  end

  def increase_speed
    schedule do
      if speed >=0 && speed <= 80
        self.speed += 20
      end
    end
  end

  def decrease_speed
    schedule do
      if speed > 20 && speed <= 100
        self.speed -= 20
      end
    end
  end

  def stop_motors
    schedule do
      motor_A.stop
      motor_B.stop
    end
  end

end

bot.start do
  bot.speed = 60
  loop do
    unless bot.sensor_3.distance == 0
      puts "*****SENSOR DISTANCE:*****"
      puts bot.sensor_3.distance
    end
    char = HighLine::SystemExtensions.get_character
    case char.chr
    when 'w'
      bot.move_forward
    when 'd'
      bot.turn_left
    when 'a'
      bot.turn_right
    when 'x'
      bot.move_backward
    when 'o'
      bot.increase_speed
    when 'l'
      bot.decrease_speed
    when 'e', 'c', 'z', 'q'
      bot.stop_motors
    end
  end
end
```

### Sensors

You can read values from sensors by doing something like this:

```
bot = BrickPi.create do |bot|
  bot.touch_sensor :port_1
end
bot.run do
  bot.sensor_1.read
end
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

