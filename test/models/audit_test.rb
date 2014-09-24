require "test_helper"

class AuditTest < ActiveSupport::TestCase

  def test_logger
    assert_respond_to Audit, :logger

    message = 'This is a test'
    Audit.logger :test_ident, message

    audit = Audit.first

    assert_equal 'TestIdent', audit.ident
    assert_equal message, audit.message
  end

end
