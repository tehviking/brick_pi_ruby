require 'mkmf'
find_header 'wiringPi.h'
find_library 'wiringPi', 'serialOpen'
create_makefile 'brick_pi/native'
