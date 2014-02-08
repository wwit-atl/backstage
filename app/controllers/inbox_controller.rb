class InboxController < ApplicationController
  skip_authorization_check
  include Mandrill::Rails::WebHookProcessor
  authenticate_with_mandrill_keys! ENV['MANDRILL_WEBHOOK_KEY']
end