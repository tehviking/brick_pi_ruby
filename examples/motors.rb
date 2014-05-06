#!/usr/bin/env ruby

require 'brick_pi'

# Instantiate the Bot
bot = BrickPi.create do |bot|
  bot.motor :port_B
  bot.motor :port_C
end

# Get this party started
bot.start

# Half speed on both motors. Max value is 100.
bot.motor_B.spin 50
bot.motor_C.spin 50

sleep 5

# Stop motors
bot.motor_B.stop
bot.motor_C.stop

# Stop all functions for a bot
bot.stop
