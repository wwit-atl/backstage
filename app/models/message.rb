class Message < ActiveRecord::Base
  include MessagesHelper

  has_and_belongs_to_many :members
  belongs_to :sender,   class_name: Member, :foreign_key => :sender_id
  belongs_to :approver, class_name: Member, :foreign_key => :approver_id
  before_save :check_and_add_members

  scope :by_created,   -> { order(:created_at   => :desc) }
  scope :by_sent,      -> { order(:sent_at      => :desc) }
  scope :by_delivered, -> { order(:delivered_at => :desc) }

  #scope :for_member,   ->(member) { joins(:members).where('members'.exists?(member)) | where(sender_id: member.id) }
  #scope :for_member,   ->(member) { joins(:members).where( ('members.id' == 5) | (:sender_id == 5) ).uniq }
  #joins(:members).where(('members.id' == 5) | (:sender_id == 5)).uniq
  #scope :to_member, ->(member) { joins(:members).where(members: {id: member.id}) }
  #scope :by_sender, ->(member) { where(sender: member) }
  scope :for_member, ->(member) { joins{members}.where { (sender == member) | (members.id == member.id) }.uniq }

  alias_attribute :text, :message

  validates_presence_of :subject, :message

  def approved?
    !approver.nil?
  end

  def sent?
    !sent_at.nil?
  end

  def delivered?
    !delivered_at.nil?
  end

  def formatted_text(format = nil)
    markdown message, format
  end

  def date
    created_at.strftime('%D')
  end

  def time_stamp(column = :delivered, format_type = :short)
    format = format_type.to_sym == :short ? '%D %I:%M %p' : '%A%n%B %e, %Y%n%I:%M %p'
    self.send(column.to_s + '_at').localtime.strftime(format)
  end

  def status_class
    return 'status-red'    if !approved?
    return 'status-yellow' if !delivered?
    'status-green'
  end

  private

  def check_and_add_members
    self.members = Member.company_members if self.members.empty?
  end

end
