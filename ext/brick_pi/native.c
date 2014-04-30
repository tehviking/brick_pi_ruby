#include "ruby.h";
#include "tick.h";
#include "BrickPi.h";

VALUE bprb_BrickPiSetup(VALUE self) {
    return INT2FIX(BrickPiSetup());
}

VALUE bprb_BrickPiSetupSensors(VALUE self) {
    return INT2FIX(BrickPiSetupSensors());
}

VALUE bprb_ClearTick(VALUE self) {
    return INT2FIX(ClearTick());
}

VALUE bprb_MotorSpeed_set(VALUE self, VALUE key, VALUE value) {
    int index = FIX2INT(key);
    BrickPi.MotorSpeed[index] = FIX2INT(value);
    return value;
}

VALUE bprb_Address_set(VALUE self, VALUE key, VALUE value) {
    int index = FIX2INT(key);
    BrickPi.Address[index] = FIX2INT(value);
    return value;
}

VALUE bprb_MotorEnable_set(VALUE self, VALUE key, VALUE value) {
    int index = FIX2INT(key);
    BrickPi.MotorEnable[index] = FIX2INT(value);
    return value;
}

VALUE bprb_Timeout_set(VALUE self, VALUE timeout) {
    BrickPi.Timeout = FIX2INT(timeout);
    return timeout;
}

VALUE bprb_SensorType_set(VALUE self, VALUE key, VALUE value) {
    int index = FIX2INT(key);
    BrickPi.SensorType[index] = FIX2INT(value);
    return value;
}

VALUE bprb_Sensor_get(VALUE self, VALUE key) {
    int index = FIX2INT(key);
    return INT2FIX(BrickPi.Sensor[index]);
}

VALUE bprb_Encoder_get(VALUE self, VALUE key) {
    int index = FIX2INT(key);
    return INT2FIX(BrickPi.Encoder[index]);
}

VALUE bprb_BrickPiSetTimeout(VALUE self) {
    return INT2FIX(BrickPiSetTimeout());
}

VALUE bprb_BrickPiUpdateValues(VALUE self) {
    return INT2FIX(BrickPiUpdateValues());
}

void Init_native() {
    VALUE BrickPi = rb_define_module("BrickPi");
    VALUE Native = rb_define_module_under(BrickPi, "Native");
    rb_define_singleton_method(Native, "BrickPiSetup", bprb_BrickPiSetup, 0);
    rb_define_singleton_method(Native, "BrickPiSetupSensors", bprb_BrickPiSetupSensors, 0);
    rb_define_singleton_method(Native, "ClearTick", bprb_ClearTick, 0);
    VALUE MotorSpeed = rb_define_module_under(Native, "MotorSpeed");
    rb_define_singleton_method(MotorSpeed, "[]=", bprb_MotorSpeed_set, 2);
    VALUE MotorEnable = rb_define_module_under(Native, "MotorEnable");
    rb_define_singleton_method(MotorEnable, "[]=", bprb_MotorEnable_set, 2);
    VALUE Address = rb_define_module_under(Native, "Address");
    rb_define_singleton_method(Address, "[]=", bprb_Address_set, 2);
    VALUE SensorType = rb_define_module_under(Native, "SensorType");
    rb_define_singleton_method(SensorType, "[]=", bprb_SensorType_set, 2);
    VALUE Sensor = rb_define_module_under(Native, "Sensor");
    rb_define_singleton_method(Sensor, "[]", bprb_Sensor_get, 1);
    VALUE Encoder = rb_define_module_under(Native, "Encoder");
    rb_define_singleton_method(Encoder, "[]", bprb_Encoder_get, 1);

    rb_define_singleton_method(Native, "Timeout=", bprb_Timeout_set, 1);
    rb_define_singleton_method(Native, "BrickPiSetTimeout", bprb_BrickPiSetTimeout, 0);
    rb_define_singleton_method(Native, "BrickPiUpdateValues", bprb_BrickPiUpdateValues, 0);
    rb_define_const(Native, "PORT_A", INT2FIX(0));
    rb_define_const(Native, "PORT_B", INT2FIX(1));
    rb_define_const(Native, "PORT_C", INT2FIX(2));
    rb_define_const(Native, "PORT_D", INT2FIX(3));
    rb_define_const(Native, "PORT_1", INT2FIX(0));
    rb_define_const(Native, "PORT_2", INT2FIX(1));
    rb_define_const(Native, "PORT_3", INT2FIX(2));
    rb_define_const(Native, "PORT_4", INT2FIX(3));
    rb_define_const(Native, "US_PORT", INT2FIX(2));
    rb_define_const(Native, "TYPE_SENSOR_TOUCH", INT2FIX(32));
    rb_define_const(Native, "TYPE_SENSOR_ULTRASONIC_CONT", INT2FIX(33));
    rb_define_const(Native, "TYPE_SENSOR_ULTRASONIC_SS", INT2FIX(34));
    rb_define_const(Native, "TYPE_SENSOR_COLOR_FULL", INT2FIX(36));
    rb_define_const(Native, "TYPE_SENSOR_COLOR_RED", INT2FIX(37));
    rb_define_const(Native, "TYPE_SENSOR_COLOR_GREEN", INT2FIX(38));
    rb_define_const(Native, "TYPE_SENSOR_COLOR_BLUE", INT2FIX(39));
    rb_define_const(Native, "TYPE_SENSOR_COLOR_NONE", INT2FIX(40));
}
