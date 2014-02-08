class Message < ActiveRecord::Base
  has_and_belongs_to_many :members
  belongs_to :sender,   class_name: Member, :foreign_key => :sender_id
  belongs_to :approver, class_name: Member, :foreign_key => :approver_id

  scope :by_created,   -> { order(:created_at => :desc) }
  scope :by_sent,      -> { order(:sent_at => :desc) }
  scope :by_delivered, -> { order(:delivered_at => :desc) }

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

  def time_stamp(column = :delivered, format_type = :short)
    format = format_type.to_sym == :short ? '%D %I:%M %p' : '%A%n%B %e, %Y%n%I:%M %p'
    self.send(column.to_s + '_at').localtime.strftime(format)
  end

  def send_email
    # ToDo: Actually send emails here
    self.sent_at = Time.now()
    self.save
  end

  def status
    return 'status-red'    if !approved?
    return 'status-yellow' if !delivered?
    'status-green'
  end
end
