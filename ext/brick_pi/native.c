#include "ruby.h";
#include "tick.h";
#include "BrickPi.h";

VALUE bprb_BrickPiSetup(VALUE self) {
    return INT2FIX(BrickPiSetup());
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
    rb_define_singleton_method(Native, "ClearTick", bprb_ClearTick, 0);
    VALUE MotorSpeed = rb_define_module_under(Native, "MotorSpeed");
    rb_define_singleton_method(MotorSpeed, "[]=", bprb_MotorSpeed_set, 2);
    VALUE MotorEnable = rb_define_module_under(Native, "MotorEnable");
    rb_define_singleton_method(MotorEnable, "[]=", bprb_MotorEnable_set, 2);
    VALUE Address = rb_define_module_under(Native, "Address");
    rb_define_singleton_method(Address, "[]=", bprb_Address_set, 2);
    rb_define_singleton_method(Native, "Timeout=", bprb_Timeout_set, 1);
    rb_define_singleton_method(Native, "BrickPiSetTimeout", bprb_BrickPiSetTimeout, 0);
    rb_define_singleton_method(Native, "BrickPiUpdateValues", bprb_BrickPiUpdateValues, 0);
    rb_define_const(Native, "PORT_A", INT2FIX(0));
    rb_define_const(Native, "PORT_B", INT2FIX(1));
    rb_define_const(Native, "PORT_C", INT2FIX(2));
    rb_define_const(Native, "PORT_D", INT2FIX(3));
}
