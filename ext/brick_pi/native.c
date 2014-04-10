#include "ruby.h";
#include "tick.h";
#include "BrickPi.h";

VALUE call_brick_pi_setup(VALUE self) {
    return INT2FIX(BrickPiSetup());
}

void Init_native() {

    VALUE BrickPi = rb_define_module("BrickPi");
    VALUE Native = rb_define_module_under(BrickPi, "Native");
    rb_define_singleton_method(Native, "brick_pi_setup", &call_brick_pi_setup, 0);
}
