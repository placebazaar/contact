require 'test_helper'

describe 'add message through REST' do
  describe 'POST /messages' do
    let(:params) do
      {
        name: 'Harry Potter',
        email: 'harry@hogwards.edu.wizard',
        message: 'Wingardium Leviosar'
      }
    end

    it 'delivers the message over SMTP to reciever' do
      assert_changes 'Mail::TestMailer.deliveries.length', from: 0, to: 1 do
        post '/messages', params
        assert_response 201
        assert_equal %w[webmaster@example.com], last_mail.to
        assert_equal %w[contact@placebazaar.org], last_mail.from
        assert_equal %w[harry@hogwards.edu.wizard], last_mail.reply_to
        assert_includes last_mail.body.to_s, 'Wingardium Leviosar'
        assert_includes last_mail.body.to_s, 'name: Harry Potter'
        assert_includes last_mail.body.to_s, 'email: harry@hogwards.edu.wizard'

        assert_equal '', last_response.body
      end
    end

    it 'validates that all fields are set' do
      assert_no_changes 'Mail::TestMailer.deliveries.length' do
        post '/messages', {}
        assert_response(400)
      end
    end

    it 'validates length of email' do
      assert_no_changes 'Mail::TestMailer.deliveries.length' do
        post '/messages', params.merge(email: 'x' * 256)
        assert_response(400)
      end
    end

    it 'validates length of name' do
      assert_no_changes 'Mail::TestMailer.deliveries.length' do
        post '/messages', params.merge(name: 'x' * 256)
        assert_response(400)
      end
    end

    it 'validates length of message' do
      assert_no_changes 'Mail::TestMailer.deliveries.length' do
        post '/messages', params.merge(message: 'x' * 3000)
        assert_response(400)
      end
    end

    private

    def last_mail
      Mail::TestMailer.deliveries.last
    end
  end
end
