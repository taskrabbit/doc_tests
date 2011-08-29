module DocTests
  # Your code goes here...
end

require 'redcarpet'

require 'doc_tests/config'
require 'doc_tests/document'
require 'doc_tests/dispatch'
require 'doc_tests/element'

require 'doc_tests/elements/cucumber'
require 'doc_tests/elements/request'

DocTests::Config.register(DocTests::Elements::Cucumber)

