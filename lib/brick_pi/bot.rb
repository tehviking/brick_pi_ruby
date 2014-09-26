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
      @behaviors = []
    end

    def start
      @stop = false
      Native.ClearTick()
      Native.Timeout = 50
      Native.BrickPiSetTimeout()
      @thread = Thread.new do
        until @stop do
          tick()
          Native.BrickPiUpdateValues()
          sleep 50/1000
        end
      end
    end

    def wait
      @thread.join if @thread
    end

    def tick
      self.class.devices.each { |d| d.zero }
      next_behaviors = []
      @behaviors.sort.each do |behavior|
        behavior.apply(next_behaviors)
        if behavior.active?
          next_behaviors << behavior
        end
      end

      @behaviors = next_behaviors
      self.class.properties.each { |p| p.apply self }
    rescue Exception => e
      $stderr.puts e.message
      $stderr.puts e.backtrace.join "\n"
    end

    def add_behavior(*behaviors)
      @behaviors.concat behaviors
    end

    def stop
      @stop = true
      @thread = nil
    end

    def behavior(priority=1, &block)
      Behavior.new(priority, &block).tap do |behavior|
        @behaviors << behavior
      end
    end

    class Behavior
      attr_reader :priority

      def initialize(priority, &body)
        @priority, @body = priority, body
        @active = true
        @started_at = Time.now
        @then = nil
      end

      def apply(next_behaviors)
        stop = proc do
          @active = false
          if @then
            behavior = @then.call
            next_behaviors << behavior
          end
        end
        @body.call(Time.now - @started_at, stop)
      end

      def active?
        @active
      end

      def then(&block)
        @then = block
        return self
      end

      # Higher priority items are run last, stomping on other behaviors
      def <=>(other)
        priority <=> other.priority
      end
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
