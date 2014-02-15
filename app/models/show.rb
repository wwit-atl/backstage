class Show < ActiveRecord::Base
  can_be_scheduled

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

  scope :recent, -> { where('date > ?', Date.today - 30.days) }
  scope :by_date, -> { order(:date) }

  scope :for_month, ->(cdate = Date.today) { where('date >= ? AND date <= ?', cdate.beginning_of_month, cdate.end_of_month) }

  default_scope { by_date }

  validates_presence_of :date

  def call_time
    format_time(calltime)
  end

  def show_time
    format_time(showtime)
  end

  def human_date
    date.strftime('%m/%d/%Y')
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

  def shift(code = nil)
    return unless code
    shifts.where(skill: Skill.class_eval(code.to_s.downcase)).first
  end
end
