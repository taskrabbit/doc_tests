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
  s.summary     = %q{Documentation with built-in integration testing}
  s.description = %q{Documentation with built-in integration testing}

  s.rubyforge_project = "doc_tests"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features,markdown}/*`.split("\n")
  s.executables   = ["doctests"]
  s.require_paths = ["lib"]
  
  s.add_dependency('redcarpet', '~> 2.0.0b3')
  s.add_dependency('cucumber', '=0.10.7')
  s.add_dependency('gherkin', '=2.4.0')
  
  s.add_dependency('nokogiri', '> 0.0.0')
  
  s.add_development_dependency('rails', '=2.3.10')
  s.add_development_dependency('rspec', '=1.3.0')
  s.add_development_dependency('rspec-rails', '=1.3.2')
  s.add_development_dependency('mocha', '=0.9.8')
  s.add_development_dependency('ruby-debug', '=0.10.3')
  
  
  s.add_development_dependency('cucumber-rails', '=0.3.2')
  s.add_development_dependency('capybara', '=0.3.9')
end
