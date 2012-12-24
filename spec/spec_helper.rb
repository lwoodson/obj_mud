$: << File.join('..', 'lib')
require 'factory_girl'
require 'factories'

RSpec.configure do |config|
  config.mock_framework = :mocha
end
