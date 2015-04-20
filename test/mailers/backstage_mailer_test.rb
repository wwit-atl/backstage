require 'test_helper'

class BackstageMailerTest < ActionMailer::TestCase

  test 'action_mailer config' do
    assert_equal Backstage::Application.config.action_mailer.smtp_settings, {
        :domain         => ENV['MANDRILL_DOMAIN']       || 'wholeworldtheatre.com',
        :port           => ENV['MANDRILL_SMTP_PORT']    || '587',
        :address        => ENV['MANDRILL_SMTP_ADDRESS'] || 'smtp.mandrillapp.com',
        :user_name      => ENV['MANDRILL_USERNAME'],
        :password       => ENV['MANDRILL_TESTING'] != 'true' ? ENV['MANDRILL_APIKEY'] : ENV['MANDRILL_TEST_APIKEY'],
        :authentication => :plain
    }
    assert_equal Backstage::Application.config.action_mailer.default_options, {
        :from           => 'Laughing Larry <larry@wholeworldtheatre.com>',
        :to             => 'Laughing Larry <larry@wholeworldtheatre.com>',
        :reply_to       => ENV['DEFAULT_REPLY_TO'] || 'Eric Goins <eric@wholeworldtheatre.com>'
    }
  end

  test 'announcement' do
    message = FactoryGirl.create( :message, :approved )
    email = nil

    refute message.sent?, 'Message should not yet be sent'

    assert_emails 1 do
      email = BackstageMailer.announcements(message).deliver_now
    end

    assert_equal "[WWIT-ANNOUNCEMENT] #{message.subject}", email.subject

    assert message.reload.approved?, 'Message should be approved'
    assert message.reload.sent?, 'Message should be sent'
    refute message.reload.delivered?, 'Message should not be delivered'
  end

end
