#!/usr/bin/env ruby

require 'brick_pi'

bot = BrickPi::Bot.new

bot.sensor_1.configure :port_1, :ultrasonic

bot.run do

  while true
    puts bot.sensor_1.distance
  end

end
