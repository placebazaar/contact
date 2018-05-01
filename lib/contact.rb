require 'sinatra'
require 'pony'

UnprocessableEntity = Class.new(StandardError)
BadRequest = Class.new(StandardError)

error UnprocessableEntity do |error|
  body "Unprocessable Entity: #{error.message}"
  status 422
end

error BadRequest do |error|
  body "Bad Request: #{error.message}"
  status 400
end

def json_params
  # Coerce this into a symbolised Hash so Sintra data structures
  # don't leak into the command layer.
  Hash[
    params.merge(
      JSON.parse(request.body.read)
    ).map { |k, v| [k.to_sym, v] }
  ]
end

post '/message' do
  status 201
end

## Core namespace for the app
module Contact
  ## Holds the configuration, singleton with a class variable.
  class Config
    attr_accessor :mail_to, :mail_from, :smtp_options
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield config
  end

  def self.environment
    ENV.fetch('RACK_ENV', 'development')
  end
end

require_relative '../config/environment.rb'
