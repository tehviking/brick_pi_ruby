module BrickPi
  class Motor
    def initialize(port)
      @port = port
      Native::MotorEnable[@port] = 1
    end

    def spin(speed)
      speed = [-100, [100, speed].min].max
      motor_speed = (speed * 2.55).round
      puts motor_speed
      Native::MotorSpeed[@port] = motor_speed
    end

    def stop
      spin 0
    end
  end
end
