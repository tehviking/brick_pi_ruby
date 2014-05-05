#!/usr/bin/env ruby

require 'brick_pi'

bot = BrickPi::Bot.new

bot.sensor1 = BrickPi::Sensor.new(:port_1, :touch)

bot.start
puts "waiting..."

until bot.sensor1.touched?
  # nothing - just wait for a touch
end

puts "touched!"
