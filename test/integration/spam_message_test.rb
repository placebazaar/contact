# frozen_string_literal: true

require 'test_helper'

describe 'attempt to spam message through REST' do
  let(:params) do
    {
      name: 'Harry Potter',
      email: 'harry@hogwards.edu.wizard',
      message: 'Wingardium Leviosar',
      contact_captcha: 'true'
    }
  end

  describe 'POST /messages' do
    it 'does not send the message over SMTP but fakes the response' do
      assert_no_changes 'Mail::TestMailer.deliveries.length' do
        post '/messages', params
        assert_response 201
      end
    end
  end
end
