# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "fluent-plugin-serialport"
  s.version     = "0.0.1"
  s.authors     = ["MATSUMOTO Katsuyoshi"]
  s.email       = ["matsumoto.katsuyoshi+rubygems@gmail.com"]
  s.homepage    = "https://github.com/katsyoshi/fluent-plugin-serialport"
  s.summary     = %q{fluentd plugin for serial port}
  s.description = %q{fluentd plugin for serial port}

  s.rubyforge_project = "fluent-plugin-serialport"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "fluentd", ">=0.10.7"
  s.add_development_dependency "serialport"
  s.add_runtime_dependency "fluentd", ">=0.10.7"
  s.add_runtime_dependency "serialport"
end
