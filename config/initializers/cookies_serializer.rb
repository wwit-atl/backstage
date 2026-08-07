# Be sure to restart your server when you modify this file.

# Rails 4.2 defaults to :marshal when this is unset. Marshal deserialization of
# session cookies turns any SECRET_KEY_BASE disclosure into remote code
# execution rather than mere session forgery, so pin it to :json.
#
# :hybrid is deliberately NOT used here -- it still deserializes existing Marshal
# cookies on read, which leaves that path open. Rotating SECRET_KEY_BASE
# invalidates every outstanding session anyway, so there is nothing to migrate.
#
# Safe for this app: the session only ever holds strings and arrays of strings
# (:redirect_to, :next, :date_params). See MembersController#schedule -- it reads
# session[:exceptions], but nothing writes it.
Backstage::Application.config.action_dispatch.cookies_serializer = :json
