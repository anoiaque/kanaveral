# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kanaveral/version'

Gem::Specification.new do |spec|
  spec.name          = "kanaveral"
  spec.version       = Kanaveral::VERSION
  spec.authors       = ["Philippe Cantin"]
  spec.email         = ["anoiaque@me.com"]

  spec.summary       = %q{Simple and flexible deployment/automation tool}
  spec.description   = %q{Kanaveral is a flexible deployment/automation tool.Its purpose is for app deployment and/or server installation.}
  spec.homepage      = "https://github.com/anoiaque/kanaveral"
  spec.license       = "MIT"
  spec.required_ruby_version = '~> 2.0'
  
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  
  spec.add_dependency 'net-ssh'
  spec.add_dependency 'rainbow'
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
