# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/assert_changes'
require 'byebug'

# Set up fake ENV vars
ENV['MAIL_TO'] = 'webmaster@example.com'

require 'contact'

require 'awesome_print'
require 'ostruct'

ENV['RACK_ENV'] = 'test'

Sinatra::Application.environment = :test

## Include all support files
Dir[File.join(__dir__, 'support', '**', '*.rb')].sort.each { |file| require file }

module Minitest
  class Spec
    include FileHelpers
    include RequestHelpers
    include TimeHelpers

    before do
      Pony.override_options = { via: :test }
      Mail::TestMailer.deliveries.clear
    end
  end
end
