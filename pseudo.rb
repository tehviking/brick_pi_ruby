require 'brick_pi'
include BrickPi

class BrickBot
  def start
    @stop = false
    motor1 = Native::PORT_A
    motor2 = Native::PORT_B
    Native.ClearTick()
    Native.BrickPiSetup()
    Native::Address[0] = 1
    Native::Address[1] = 2
    Native::MotorEnable[motor1] = 1
    Native::MotorEnable[motor2] = 1

    Native.Timeout = 50
    Native.BrickPiSetTimeout()
    Native::MotorSpeed[motor1] = 200
    Native::MotorSpeed[motor2] = -200

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
