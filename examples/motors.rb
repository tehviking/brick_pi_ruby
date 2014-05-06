#!/usr/bin/env ruby

require 'brick_pi'

# Instantiate the Bot
bot = BrickPi::Bot.new

# Get this party started
bot.run do

  # Half speed on both motors. Max value is 100.
  bot.motor_B.spin 50
  bot.motor_C.spin 50

  sleep 5

  # Stop motors
  bot.motor_B.stop
  bot.motor_C.stop

end
