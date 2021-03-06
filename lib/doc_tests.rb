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
require 'doc_tests/cucumber/options'
require 'doc_tests/cucumber/configuration'
require 'doc_tests/cucumber/features'
require 'doc_tests/cucumber/runtime'
require 'doc_tests/cucumber/main'

require 'doc_tests/parser'
require 'doc_tests/parsers/tester'
require 'doc_tests/parsers/yml'
require 'doc_tests/parsers/json'
require 'doc_tests/parsers/xml'
require 'doc_tests/parsers/html'
require 'doc_tests/parsers/rack'
require 'doc_tests/parsers/nokogiri'
require 'doc_tests/parsers/form_urlencoded'

require 'doc_tests/equivalency'

require 'doc_tests/elements/cucumber'
require 'doc_tests/elements/request'
require 'doc_tests/elements/response'

DocTests::Config.register(DocTests::Elements::Cucumber)
DocTests::Config.register(DocTests::Elements::Request)
DocTests::Config.register(DocTests::Elements::Response)
