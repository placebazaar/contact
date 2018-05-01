require 'sinatra'

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

  ##
  # Deliver contact to this email, or list of emails.
  def self.mail_to
    EventSourcery::Postgres.config.mail_to
  end

  ##
  # Pony +via_options+ for SMTP server delivery
  # :address              => 'smtp.gmail.com',
  # :port                 => '587',
  # :enable_starttls_auto => true,
  # :user_name            => 'user',
  # :password             => 'password_see_note',
  # :authentication       => :plain, # :plain, :login, :cram_md5, no auth
  #                          by default
  # :domain               => "localhost.localdomain" # the HELO domain
  #                          provided by the client to the server
  def self.smtp_options
    EventSourcery::Postgres.config.event_options
  end
end

require_relative '../config/environment.rb'
