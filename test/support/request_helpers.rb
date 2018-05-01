require 'ostruct'
require 'json'
require 'rack/test'

module RequestHelpers
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def post_json(url, body, headers = {})
    defaults = { 'Content-Type' => 'application/json' }
    post url, body.to_json, headers.merge(defaults)
  end

  def assert_response(code)
    assert_equal code, last_response.status
  end
end
