require 'brick_pi'
include BrickPi

module BrickPi
  class Bot

    include BrickPi::Configuration

    attr_accessor :motor_A, :motor_B, :motor_C, :motor_D
    attr_accessor :sensor_1, :sensor_2, :sensor_3, :sensor_4

    def initialize
      Native.BrickPiSetup()
      Native::Address[0] = 1
      Native::Address[1] = 2
    end

    def start
      @stop = false
      Native.ClearTick()
      Native.Timeout = 50
      Native.BrickPiSetTimeout()

      Thread.new do
        until @stop do
          Native.BrickPiUpdateValues()
          sleep(50/1000)
        end
      end
    end

    def stop
      @stop = true
    end

    def run
      start
      yield
      stop
    end

  end
end
