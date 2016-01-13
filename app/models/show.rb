class Show < ActiveRecord::Base
  before_destroy :log_destroy
  before_save    :set_capacity

  store_accessor :tickets

  has_many :shifts, :dependent => :destroy
  has_many :crew_members, :through => :shifts, :source => :member
  has_many :skills, -> { order(:code) }, :through => :shifts
  has_many :scenes, -> { order(:position) }, :dependent => :destroy
  has_many :notes, :as => :notable

  belongs_to :mc, class_name: 'Member', :inverse_of => :mc_shifts
  belongs_to :group, class_name: 'Role'

  has_and_belongs_to_many :actors, class_name: 'Member', join_table: 'actors_shows'

  accepts_nested_attributes_for :scenes, allow_destroy: true
  accepts_nested_attributes_for :shifts, allow_destroy: true

  scope :recent, -> { where('date > ?', Date.today - 5.days) }
  scope :by_date, -> { order(:date, :showtime) }
  scope :by_date_desc, -> { order(:date => :desc, :showtime => :desc) }

  scope :for_date, ->(date) { where(date: date) }
  scope :for_month, ->(cdate = Date.today) { where('date >= ? AND date <= ?', cdate.beginning_of_month, cdate.end_of_month) }

  # default_scope { by_date }

  validates_presence_of :date, :name

  def call_time
    calltime.strftime('%l:%M %P')
  end

  def show_time
    showtime.strftime('%l:%M %P')
  end

  def casting_sent
    casting_sent_at.strftime('%m/%d/%Y @ %l:%M %P')
  end

  def gregorian_date
    date.strftime('%m/%d/%Y')
  end

  def human_date
    case date
      when Date.today     then 'Today'
      when Date.tomorrow  then 'Tomorrow'
      when Date.yesterday then 'Yesterday'
      else gregorian_date
    end
  end

  def year
    date.strftime('%Y').to_i
  end

  def month
    date.strftime('%m').to_i
  end

  def dow
    date.strftime('%A')
  end

  def datetime
    "#{gregorian_date} @ #{show_time}"
  end

  def title
    "#{datetime} - #{name}"
  end

  def cal_title
    "#{show_time} - #{name}"
  end

  def dowtitle
    "#{datetime} #{dow}"
  end

  def shift(code = nil)
    return unless code
    shifts.where(skill: Skill.class_eval(code.to_s.downcase)).first
  end

  def cast?
    !casting_sent_at.nil?
  end

  def to_datetime(time = :showtime)
    DateTime.new(date.year, date.month, date.day, self.send(time).in_time_zone('UTC').hour, self.send(time).in_time_zone('UTC').min)
  end

  def is_soon?
    ( 6.hours.ago.to_datetime.utc .. 24.hours.from_now.to_datetime.utc ).cover?(to_datetime)
  end

  def is_today?
    date == Date.today
  end

  def self.ticket_types
    %w(sold comp rush walkup)
  end

  def tickets_total
    Show.ticket_types.map { |t| tickets_for_type(t) }.inject(:+)
  end

  def sold_out?
    tickets_total >= ( capacity || Konfig.default_show_capacity )
  end

  # Provides accessor methods for all ticket_types
  def method_missing(method, *args)
    if Show.ticket_types.include?(method.to_s)
      tickets_for_type(method.to_s)
    else
      super
    end
  end

  def respond_to?(method, include_private = false)
    if Show.ticket_types.include?(method.to_s)
      true
    else
      super
    end
  end

  private

  def tickets_for_type(type)
    return 0 if tickets.nil?
    tickets.has_key?(type.to_s) ? tickets[type.to_s].to_i : 0
  end

  def set_capacity
    self.capacity ||= Konfig.default_show_capacity
  end

  def log_destroy
    Audit.logger self.class.to_s, "Deleted #{self.title}"
  end
end
