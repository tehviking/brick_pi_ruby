#!/usr/bin/env ruby

require 'brick_pi'

bot = BrickPi.create do |bot|
  bot.touch_sensor :port_1
end

bot.start
puts "waiting..."

until bot.sensor_1.touched?
  # nothing - just wait for a touch
end

puts "touched!"
