class InboxController < ApplicationController
  include Mandrill::Rails::WebHookProcessor
end