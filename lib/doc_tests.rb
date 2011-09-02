module DocTests
  BINARY = File.expand_path(File.dirname(__FILE__) + '/../../bin/doctests')
end

require 'redcarpet'

require 'doc_tests/config'
require 'doc_tests/document'
require 'doc_tests/markdown'
require 'doc_tests/dispatch'
require 'doc_tests/element'

require 'doc_tests/cucumber/stepper'
require 'doc_tests/cucumber/configuration'
require 'doc_tests/cucumber/features'
require 'doc_tests/cucumber/runtime'
require 'doc_tests/cucumber/main'

require 'doc_tests/elements/cucumber'
require 'doc_tests/elements/request'

require 'doc_tests/parser'
require 'doc_tests/parsers/yml'

DocTests::Config.register(DocTests::Elements::Cucumber)
DocTests::Config.register(DocTests::Elements::Request)
