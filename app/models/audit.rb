class Audit < ActiveRecord::Base
  belongs_to :member

  default_scope -> { order(:id => :desc) }

  def self.logger(ident, message)
    ident   = ident.to_s.underscore.camelize rescue 'Unknown'
    message = message.to_s rescue 'invalid or no message given'

    Audit.create( member: Member.current, ident: ident, message: message )
  end

  def self.log(ident = 'all', count = 500)
    audits = ident == 'all' ? Audit.all : Audit.where(ident: ident.to_s.underscore.camelize)
    audits = audits.limit(count) unless count == 'all'
    audits.map(&:log)
  end

  def whom
    member_id.nil? ? 'System' : member.name
  end

  def timestamp
    created_at.strftime('%F %T')
  end

  def log
    name = member.nil? ? 'system' : member.name
    '%s: (%s) [%s] %s' % [ timestamp, name, ident, message ]
  end


end
