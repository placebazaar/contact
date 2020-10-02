# frozen_string_literal: true

Contact.configure do |config|
  config.mail_to = ENV['MAIL_TO']
  config.mail_from = 'contact@placebazaar.org'
  config.smtp_options = {
    address: 'fairfax.webschuur.com',
    port: '587',
    enable_starttls_auto: true,
    user_name: ENV['SMTP_USER'],
    password: ENV['SMTP_PASSWORD'],
    authentication: :plain,
    domain: 'placebazaar.org'
  }
end
