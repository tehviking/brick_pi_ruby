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
      @queue = Queue.new
    end

    def start
      @stop = false
      Native.ClearTick()
      Native.Timeout = 50
      Native.BrickPiSetTimeout()
      Thread.new do
        until @stop do
          Native.BrickPiUpdateValues()
          sleep 50/1000
        end
      end
      Thread.new do
        until @stop do
          code = @queue.pop
          begin
            code.call
          rescue => e
            $stderr.puts e.message
            $stderr.puts e.backtrace.join("\n")
          end
        end
      end
      Thread.new do
        yield
      end.join
      stop
    end

    def stop
      schedule do
        @stop = true
      end
    end

    def schedule(&block)
      @queue.push block
    end
  end
end
