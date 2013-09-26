class Note < ActiveRecord::Base
  belongs_to :member
  belongs_to :notable, polymorphic: true
  validates_presence_of :content

  def author
    self.member.nil? ? 'Anonymous' : self.member.name
  end

  private
end
