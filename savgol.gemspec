# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'savgol/version'

Gem::Specification.new do |spec|
  spec.name          = "savgol"
  spec.version       = Savgol::VERSION
  spec.authors       = ["John T. Prince", "Ondra Beneš"]
  spec.email         = ["jtprince@gmail.com"]
  spec.summary       = %q{performs Savitzky-Golay smoothing}
  spec.description   = %q{Extends Array class with method which calculates applies Savitzky-Golay filter used for smoothing the data}
  spec.homepage      = "http://github.com/princelab/savgol"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  [
    #["trollop", "~> 2.0.0"],
  ].each do |args|
    spec.add_dependency(*args)
  end

  [
    ["bundler", "~> 1.5.1"],
    ["rake"],
    ["rspec", "~> 2.14.1"], 
    ["rdoc", "~> 4.1.0"], 
    ["simplecov", "~> 0.8.2"],
    ["gnuplot"],
  ].each do |args|
    spec.add_development_dependency(*args)
  end

end
