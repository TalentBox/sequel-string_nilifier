# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sequel/plugins/string_nilifier/version'

Gem::Specification.new do |spec|
  spec.name          = "sequel-string_nilifier"
  spec.version       = Sequel::Plugins::StringNilifier::VERSION
  spec.authors       = ["Jonathan Tron", "Joseph Halter"]
  spec.email         = ["jonathan.tron@metrilio.com", "joseph.halter@metrilio.com"]
  spec.description   = %q{Sequel plugin to store empty string as nil}
  spec.summary       = spec.description
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sequel", ">= 4.0", "< 6.0"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
