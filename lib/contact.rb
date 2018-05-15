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

post '/messages' do
  validate(params)
  raise BadRequest, errors.join("\n") if errors.any?

  @name    = params['name']
  @email   = params['email']
  @message = params['message']

  Pony.mail(reply_to: @email,
            subject: "[Contactform PlaceBazaar] #{@name}",
            body: erb(:mail_text))
  status 201
end

def validate(params)
  { email: 255, name: 255, message: 1000 }.each do |field, length|
    errors << "#{field} cannot be over #{length} characters" if
                                        params[field.to_s].to_s.length > length
    errors << "#{field} cannot be empty" if params[field].to_s.empty?
  end
end

def errors
  @errors ||= []
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

Pony.options = {
  to: Contact.config.mail_to,
  from: Contact.config.mail_from,
  via: :smtp,
  via_options: Contact.config.smtp_options
}
