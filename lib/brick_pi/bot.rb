require 'brick_pi'
include BrickPi

module BrickPi
  class Bot
    attr_accessor :motor_A, :motor_B, :motor_C, :motor_D
    attr_accessor :sensor_1, :sensor_2, :sensor_3, :sensor_4

    def initialize
      Native.BrickPiSetup()
      Native::Address[0] = 1
      Native::Address[1] = 2
      self.class.initializers.each do |initializer|
        instance_eval &initializer
      end
    end

    def start
      @stop = false
      Native.ClearTick()
      Native.Timeout = 50
      Native.BrickPiSetTimeout()
      Thread.new do
        until @stop do
          tick()
          Native.BrickPiUpdateValues()
          sleep 50/1000
        end
      end
    end

    def tick
      self.class.devices.each { |d| d.zero }
      self.class.properties.each { |p| p.apply self }
    rescue Exception => e
      $stderr.puts e.message
      $stderr.puts e.backtrace.join "\n"
    end

    def stop
      @stop = true
    end

    class << self
      attr_reader :properties, :devices, :initializers

      def property(name, &body)
        @properties ||= []
        @properties << Property.new(name, body)
        send(:attr_accessor, name)
      end

      def device(device)
        device.tap do
          @devices ||= []
          @devices << device
        end
      end

      def initializer(&body)
        @initializers ||= []
        @initializers << body
      end

      def motor(port)
        initializer do
          case port
          when :port_A
            @motor_A = self.class.device BrickPi::Motor.new(Native::PORT_A)
          when :port_B
            @motor_B = self.class.device BrickPi::Motor.new(Native::PORT_B)
          when :port_C
            @motor_C = self.class.device BrickPi::Motor.new(Native::PORT_C)
          when :port_D
            @motor_D = self.class.device BrickPi::Motor.new(Native::PORT_D)
          end
        end
      end

      def sensor(port, sensor_type)
        initializer do
          case port
          when :port_1
            @sensor_1 = self.class.device BrickPi::Sensor.new(:port_1, sensor_type)
          when :port_2
            @sensor_2 = self.class.device BrickPi::Sensor.new(:port_2, sensor_type)
          when :port_3
            @sensor_3 = self.class.device BrickPi::Sensor.new(:port_3, sensor_type)
          when :port_4
            @sensor_4 = self.class.device BrickPi::Sensor.new(:port_4, sensor_type)
          end
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

    class Property
      def initialize(name, body)
        @name, @body = name, body
      end

      def apply(bot)
        value = bot.send(@name)
        if !value.nil?
          bot.instance_exec(value, &@body)
        end
      end
    end
  end
end
