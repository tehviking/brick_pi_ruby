#!/usr/bin/env ruby

require 'brick_pi'

bot = BrickPi::Bot.new

bot.sensor1.configure :port_1, :ultrasonic

bot.start

while true
  puts bot.sensor1.distance
end
