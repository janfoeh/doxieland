# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'doxieland/version'

Gem::Specification.new do |spec|
  spec.name          = "doxieland"
  spec.version       = Doxieland::VERSION
  spec.authors       = ["Jan-Christian Foeh"]
  spec.email         = ["jan@programmanstalt.de"]

  spec.summary       = %q{A command line tool for downloading scans from the doxie go wi-fi}
  spec.description   = %q{A command line tool for downloading scans from the doxie go wi-fi}
  spec.homepage      = "https://github.com/janfoeh/doxieland"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'activesupport', '>= 4.2'
  spec.add_runtime_dependency 'apidiesel', '>= 0.10'
  spec.add_runtime_dependency 'thor', '>= 0.19'
  spec.add_runtime_dependency 'ruby-progressbar', '>= 1.7'
  spec.add_runtime_dependency 'hirb', '>= 0.7'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency 'pry-byebug', '~> 3.2.0'
  spec.add_development_dependency 'pry-rescue', '~> 1.4'
  spec.add_development_dependency 'pry-stack_explorer', '~> 0.4.9'
end
