#!/usr/bin/env ruby

require 'brick_pi'

bot = BrickPi.create do |bot|
  bot.ultrasonic_sensor :port_1
end

bot.run do

  while true
    puts bot.sensor_1.distance
  end

end
