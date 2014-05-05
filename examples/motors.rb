#!/usr/bin/env ruby

require 'brick_pi'

# Instantiate the Bot
bot = BrickPi::Bot.new

# Get this party started
bot.start

# Half speed on both motors. Max value is 100.
bot.motor2.spin 50
bot.motor3.spin 50

sleep 5

# Stop motors
bot.motor2.stop
bot.motor3.stop

# Stop all functions for a bot
bot.stop
