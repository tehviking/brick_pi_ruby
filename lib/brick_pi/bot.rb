require 'brick_pi'
include BrickPi

module BrickPi
  class Bot
    attr_accessor :motor1, :motor2

    def initialize
      Native.BrickPiSetup()
      @motor1 = ::BrickPi::Motor.new(Native::PORT_A)
      @motor2 = ::BrickPi::Motor.new(Native::PORT_B)
      @motor3 = ::BrickPi::Motor.new(Native::PORT_C)
      @motor4 = ::BrickPi::Motor.new(Native::PORT_D)
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
  end
end
