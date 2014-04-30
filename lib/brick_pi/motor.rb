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

    # Encoder reads the position of the motor in .5-degree increments,
    # Divide by 2 to get degrees
    def position
      Native::Encoder[@port] / 2
    end

    def stop
      spin 0
    end
  end
end
