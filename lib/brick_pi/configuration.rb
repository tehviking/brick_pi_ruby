module BrickPi

  def self.create &block
    bot = BrickPi::Bot.new
    bot.configure &block
    bot
  end

  module Configuration

    def configure &block
      yield self
    end

    def motor(port)
      case port
      when :port_A
        @motor_A = BrickPi::Motor.new(Native::PORT_A)
      when :port_B
        @motor_B = BrickPi::Motor.new(Native::PORT_B)
      when :port_C
        @motor_C = BrickPi::Motor.new(Native::PORT_C)
      when :port_D
        @motor_D = BrickPi::Motor.new(Native::PORT_D)
      end
    end

    def sensor(port, sensor_type)
      case port
      when :port_1
        @sensor_1 = BrickPi::Sensor.new(:port_1, sensor_type)
      when :port_2
        @sensor_2 = BrickPi::Sensor.new(:port_2, sensor_type)
      when :port_3
        @sensor_3 = BrickPi::Sensor.new(:port_3, sensor_type)
      when :port_4
        @sensor_4 = BrickPi::Sensor.new(:port_4, sensor_type)
      end
    end

    def touch_sensor(port)
      sensor(port, :touch)
    end

    def ultrasonic_sensor(port)
      sensor(port, :ultrasonic)
    end

    def color_sensor(port)
      sensor(port, :color)
    end

  end

end
