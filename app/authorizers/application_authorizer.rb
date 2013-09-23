# Other authorizers should subclass this one
class ApplicationAuthorizer < Authority::Authorizer

  # Any class method from Authority::Authorizer that isn't overridden
  # will call its authorizer's default method.
  #
  # @param [Symbol] adjective; example: `:creatable`
  # @param [Object] member - whatever represents the current member in your app
  # @return [Boolean]
  def self.default(adjective, member)
    # 'Whitelist' strategy for security: anything not explicitly allowed is
    # considered forbidden.
    member.has_role? :admin
  end
end
