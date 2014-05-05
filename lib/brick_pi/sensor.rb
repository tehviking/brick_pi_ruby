module BrickPi
  class Sensor
    SENSOR_TYPES = {
      touch: Native::TYPE_SENSOR_TOUCH,
      ultrasonic: Native::TYPE_SENSOR_ULTRASONIC_CONT,
      color: Native::TYPE_SENSOR_COLOR_FULL,
      color_red: Native::TYPE_SENSOR_COLOR_RED,
      color_green: Native::TYPE_SENSOR_COLOR_GREEN,
      color_blue: Native::TYPE_SENSOR_COLOR_BLUE,
      color_none: Native::TYPE_SENSOR_COLOR_NONE
    }

    PORT_MAP = {
      port_1: Native::PORT_1,
      port_2: Native::PORT_2,
      port_3: Native::PORT_3,
      port_4: Native::PORT_4
    }

    # So you can be all like `BrickPi::Sensor.new(:port_3, :ultrasonic)`
    def initialize(port = nil, sensor_type = nil)
      configure(port, sensor_type) if port && sensor_type
    end

    # Set up a sensor with `bot.sensor1.configure :port_3, :ultrasonic`
    def configure(port, sensor_type)
      @port = port
      @sensor_type = sensor_type
      Native::SensorType[PORT_MAP[@port]] = SENSOR_TYPES[@sensor_type]
      Native::BrickPiSetupSensors()
    end

    def read
      Native::Sensor[PORT_MAP[@port]] if @port
    end

    # Nice friendly access methods for different sensors types

    def touched?
      @sensor_type == :touch && read == 1
    end

    def distance
      read if @sensor_type == :ultrasonic
    end

  end
end
