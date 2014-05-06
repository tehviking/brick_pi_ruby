require 'spec_helper'

require 'brick_pi/configuration'

# Stub classes for testing
# Needed because otherwise native stuff gets in the way on non-brickpi machines

class BrickPi::Bot
  include BrickPi::Configuration
  attr_accessor :motor_A, :motor_B, :motor_C, :motor_D
  attr_accessor :sensor_1, :sensor_2, :sensor_3, :sensor_4
end
module Native
  PORT_A = 0
  PORT_B = 1
  PORT_C = 2
  PORT_D = 3
end
class BrickPi::Motor
  attr_accessor :port
  def initialize(port)
    @port = port
  end
end
class BrickPi::Sensor
  attr_accessor :port, :sensor_type
  def initialize(port, sensor_type)
    @port = port
    @sensor_type = sensor_type
  end
end

# Test configuration block

describe BrickPi::Configuration do

  it "should configure motors" do

    # Initialise bot using DSL
    bot = BrickPi.create do |bot|
      bot.motor :port_B
      bot.motor :port_C
    end

    # Check bot was created right
    bot.should_not be_nil
    bot.motor_A.should be_nil
    bot.motor_B.port.should eql Native::PORT_B
    bot.motor_C.port.should eql Native::PORT_C
    bot.motor_D.should be_nil

  end

  it "should configure sensors" do

    # Initialise bot using DSL
    bot = BrickPi.create do |bot|
      bot.touch_sensor :port_1
      bot.ultrasonic_sensor :port_2
      bot.color_sensor :port_3
    end

    # Check bot was created right
    bot.should_not be_nil
    bot.sensor_1.port.should == :port_1
    bot.sensor_1.sensor_type.should == :touch
    bot.sensor_2.port.should == :port_2
    bot.sensor_2.sensor_type.should == :ultrasonic
    bot.sensor_3.port.should == :port_3
    bot.sensor_3.sensor_type.should == :color
    bot.sensor_4.should be_nil

  end

end
