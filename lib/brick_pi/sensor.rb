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

    def initialize(port, sensor_type)
      @port = port
      @sensor_type = sensor_type
      Native::SensorType[@port] = SENSOR_TYPES[@sensor_type]
      Native::BrickPiSetupSensors()
    end

    def read
      Native::Sensor[@port]
    end
  end
end
