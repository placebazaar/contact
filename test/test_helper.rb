require 'minitest/autorun'
require 'byebug'

require 'contact'

require 'awesome_print'
require 'ostruct'

ENV['RACK_ENV'] = 'test'
Sinatra::Application.environment = :test

## Include all support files
Dir[File.join(__dir__, 'support', '**', '*.rb')].each { |file| require file }

module Minitest
  class Spec
    include FileHelpers
    include RequestHelpers
    include TimeHelpers
  end
end
