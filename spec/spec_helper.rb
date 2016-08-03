$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'hayrick'
require 'sequel'
require 'database_cleaner'

require_relative 'support/database_setup'
require_relative 'support/helpers'

RSpec.configure do |config|
  config.include Helpers

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end
end
