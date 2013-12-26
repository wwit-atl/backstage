class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  rolify

  has_many :conflicts, :dependent => :destroy
  has_many :notes, :as => :notable
  has_many :shifts
  has_many :crews, :through => :shifts, :source => :show
  has_many :phones, :dependent => :destroy

  has_and_belongs_to_many :shows, join_table: 'actors_shows'
  has_and_belongs_to_many :skills

  accepts_nested_attributes_for :phones, allow_destroy: true

  validates_presence_of :email, :firstname, :lastname
  validates_uniqueness_of :email

  #scope :castable, -> { includes(:skills).where(skills: { category: 'cast' }) }
  #scope :crewable, -> { includes(:skills).where(skills: { category: 'crew' }) }
  scope :castable, -> { joins(:skills).merge(Skill.castable) }
  scope :crewable, -> { joins(:roles).merge(Role.crewable) }

  scope :has_role,  ->(role) { joins(:roles).where(roles: {name: role}) }
  scope :has_skill, ->(skill) { joins(:skills).where(skills: {code: skill.upcase}) }

  scope :by_name, -> { order(:lastname) }

  def fullname
    [ firstname, lastname ].map{ |n| n.capitalize }.join(' ')
  end
  alias :name :fullname

  def conflict?(date)
    (year, month, day) = date.strftime('%Y|%m|%d').split('|')
    !self.conflicts.where(year: year, month: month, day: day).empty?
  end

  def has_shift_for?(show)
    self.crews.map{ |crew| crew.id }.include?(show.id)
  end

  # Returns true if eligible, 0 if at min_shifts, false if ineligible
  def eligible_for_shift?(show, min_shifts, max_shifts)
    # Is the member already at the maximum number of shifts?
    return false if shift_count_for_month(show.month) >= max_shifts

    # Does the member have a conflict for this date?
    return false if conflict?(show.date)

    # Is the member already scheduled on a shift for this show?
    return false if has_shift_for?(show)

    # Has the member reached the minimum shift limit?
    # If so, add them to the potential crew list
    return 0 if shift_count_for_month(show.month) >= min_shifts

    return true
  end

  def shift_count_for_month(month = Time.now.month, year = Time.now.year)
    date = Date.new(year, month)
    shifts.joins(:show).where( 'shows.date' => date.beginning_of_month..date.end_of_month ).count
  end
end
