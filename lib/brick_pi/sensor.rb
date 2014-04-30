module BrickPi
  class Sensor
    def initialize(port, sensor_type)
      @port = port
      @sensor_type = sensor_type
      Native::SensorType[@port] = @sensor_type
      Native::BrickPiSetupSensors()
    end

    def read
      Native::Sensor[@port]
    end
  end
end
