# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'brick_pi/version'

Gem::Specification.new do |spec|
  spec.name          = "brick-pi"
  spec.version       = BrickPi::VERSION
  spec.authors       = ["Brandon Hays", "Charles Lowell"]
  spec.email         = ["brandon.hays@gmail.com"]
  spec.summary       = %q{Ruby library to run the BrickPi drivers for Lego Mindstorms}
  spec.description   = %q{BrickPi uses a C library to communicate with Lego Mindstorms motors and sensors via GPIO on the Raspberry Pi. This library wraps the C and exposes a nicer, object-oriented interface via Ruby.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib", "ext"]
  spec.extensions    = ["ext/brick_pi/extconf.rb"]
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
