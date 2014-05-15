require "test_helper"

class MessagesControllerTest < ActionController::TestCase

  def setup
    @message = FactoryGirl.create(:message)
  end

end
