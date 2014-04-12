require 'brick_pi'
include BrickPi
motor1 = Native::PORT_A
motor2 = Native::PORT_B
Native.ClearTick()
Native.BrickPiSetup()
Native::MotorSpeed[motor1] = 200
Native::MotorSpeed[motor2] = -200
Native::Address[0] = 1
Native::Address[1] = 2
Native::MotorEnable[motor1] = 1
Native::MotorEnable[motor2] = 1
Native.Timeout = 3000
Native.BrickPiSetTimeout()
Native.BrickPiUpdateValues()
