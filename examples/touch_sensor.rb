#!/usr/bin/env ruby

require 'brick_pi'

bot = BrickPi::Bot.new

bot.sensor_1.configure :port_1, :touch

bot.start
puts "waiting..."

until bot.sensor_1.touched?
  # nothing - just wait for a touch
end

puts "touched!"
