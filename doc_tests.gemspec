# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "doc_tests/version"

Gem::Specification.new do |s|
  s.name        = "doc_tests"
  s.version     = DocTests::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brian Leonard"]
  s.email       = ["brian@bleonard.com"]
  s.homepage    = ""
  s.summary     = %q{API documentation with built-in integration testing}
  s.description = %q{API documentation with built-in integration testing}

  s.rubyforge_project = "doc_tests"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency('redcarpet', '~> 2.0.0b3')
  
  s.add_development_dependency('rails', '~> 2.3.10')
  s.add_development_dependency('rspec', '~> 1.3.0')
  s.add_development_dependency('rspec-rails', '~> 1.3.2')
  s.add_development_dependency('mocha', '~> 0.9.8')
end
