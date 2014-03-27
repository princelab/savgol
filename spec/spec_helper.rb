require 'simplecov'
SimpleCov.start

require 'rspec'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.color = true
end
