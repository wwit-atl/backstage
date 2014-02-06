class Message < ActiveRecord::Base
  has_and_belongs_to_many :members
  belongs_to :sender,   class_name: Member, :foreign_key => :sender_id
  belongs_to :approver, class_name: Member, :foreign_key => :approver_id

  scope :by_sent, -> { order(:created_at => :desc) }

  validates_presence_of :subject, :message
  after_save  :send_email

  def approved?
    !approver.nil?
  end

  def delivered?
    !sent_at.nil?
  end

  def sent_stamp
    sent_at.localtime.strftime('%D %I:%M %p')
  end

  def created_stamp
    created_at.localtime.strftime('%A%n%B %e, %Y%n%I:%M %p')
  end

  def status
    return 'status-red'    if !approved?
    return 'status-yellow' if !delivered?
    'status-green'
  end

  def send_email
    if self.approved?
      true
    else
      false
    end
  end
end
