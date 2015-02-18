require 'test_helper'

class BackstageMailerTest < ActionMailer::TestCase

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
