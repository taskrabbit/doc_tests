require 'rubygems'
require 'bundler'

Bundler.setup

RAILS_ENV = 'test'

# Load Rails
require 'active_support'
require 'action_controller'
require 'action_mailer'
require 'rails/version'



RAILS_ROOT = File.join(File.dirname(__FILE__), 'rails')
$:.unshift(RAILS_ROOT)

#ActionController::Base.view_paths = RAILS_ROOT
#Dir[File.expand_path(File.join(RAILS_ROOT, '**', '*.rb'))].each { |f| require f }

require File.join(RAILS_ROOT, 'config', 'environment.rb')

require 'spec/autorun'
require 'spec/rails'

require 'doc_tests'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end
