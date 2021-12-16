# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'be_protected/version'

Gem::Specification.new do |spec|
  spec.name          = "be_protected"
  spec.version       = BeProtected::VERSION
  spec.authors       = ["Mikhail Davidovich"]
  spec.email         = ["mihaildv@gmail.com"]
  spec.description   = %q{Ruby client for BeProtected system}
  spec.summary       = %q{Ruby client for BeProtected system}
  spec.homepage      = "http://www.ecomcharge.com/solutions/beprotected/"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "pry"
  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"
  spec.add_dependency "webmock"
end
