class Member < ActiveRecord::Base
  extend FriendlyId

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  rolify
  friendly_id :fullname, :use => :slugged

  belongs_to :last_message, class_name: Message

  has_many :conflicts, :dependent => :destroy
  has_many :notes, :as => :notable
  has_many :shifts
  has_many :crews, :through => :shifts, :source => :show
  has_many :phones, :dependent => :destroy
  has_many :addresses, :dependent => :destroy
  has_many :mc_shifts, class_name: 'Show', :foreign_key => :mc_id, :inverse_of => :mc

  has_and_belongs_to_many :shows, join_table: 'actors_shows'
  has_and_belongs_to_many :skills
  has_and_belongs_to_many :messages

  accepts_nested_attributes_for :phones, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true

  validates_presence_of :email, :firstname, :lastname, :slug
  validates_presence_of :password, on: :create
  validates_length_of :password, minimum: 5, maximum: 120, allow_blank: true
  validates_uniqueness_of :email

  scope :active,   -> { where(active: true) }
  scope :inactive, -> { where(active: false)}

  scope :castable, -> { active.joins(:roles).merge(Role.castable) }
  scope :crewable, -> { active.joins(:roles).merge(Role.crewable) }

  # ToDo Need a method that determines if a Member is eligible for a given date (checking conflicts, crews, and cast)
  #scope :castable_for_date, ->(date) { castable & !conflicts.includes?(date) & !shifts.}

  scope :company_members, -> { castable || crewable }
  scope :uses_conflicts, -> { castable || crewable }

  scope :has_role,      ->(role)  { joins(:roles).where(roles: {name: role.to_s}) }
  scope :has_skill,     ->(skill) { joins(:skills).where(skills: {code: skill.to_s.upcase}) }
  scope :has_conflict,  ->(show)  { joins(:conflicts).where(conflicts: {date: show.date}) }

  scope :by_name_first, -> { order([:firstname, :lastname]) }
  scope :by_name_last,  -> { order([:lastname, :firstname]) }
  scope :by_name,       -> { by_name_first }

  scope :admins,   -> { has_role(:admin)      }
  scope :managers, -> { has_role(:management) }
  scope :mcs,      -> { has_role(:mc)         }

  sifter :member_search do |search|
    lastname.matches("%#{search}%") | firstname.matches("%#{search}%") | email.matches("%#{search}%")
  end

  def fullname
    [ firstname, lastname ].map{ |n| n.titleize }.join(' ')
  end
  alias :name :fullname

  def casting_tag
    "#{fullname} (#{roles.castable.map{|r|r.code}})"
    "#{fullname} (#{roles.castable.map { |r| r.code }.to_sentence})"
  end

  def birthday
    dob.nil? ? 'Not Supplied' : dob.strftime('%m/%d/%Y')
  end

  def email_tag
    "#{fullname} <#{email}>"
  end

  def conflict?(date)
    (year, month, day) = date.strftime('%Y|%m|%d').split('|')
    !conflicts.where(year: year, month: month, day: day).empty?
  end

  def has_shift_for?(show)
    crews.map{ |crew| crew.id }.include?(show.id)
  end

  def is_crewable?
    active? && roles.crewable.count > 0
  end

  def is_castable?
    active? && roles.castable.count > 0
  end

  def company_member?
    active? && ( is_crewable? || is_castable? )
  end

  def uses_conflicts?
    is_castable? || is_crewable?
  end

  def is_admin?
    has_role?(:admin)
  end

  def is_active?
    active?
  end

  def inactive?
    !active?
  end

  def has_skill?(skill)
    skills.pluck(:code).include?(skill)
  end

  def eligible_for_show?(show)
    return self if show.nil?
    return nil if conflicts.map{ |c| c.date == show.date }.any?
    self
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

    true
  end

  def shift_count_for_month(month = Time.now.month, year = Time.now.year)
    date = Date.new(year, month)
    shifts.joins(:show).where( 'shows.date' => date.beginning_of_month..date.end_of_month ).count
  end

  def active_for_authentication?
    super && active?
  end

  def inactive_message
    if !active?
      :inactive
    else
      super # Use whatever other message
    end
  end

  def self.search(search)
    if search
      where{sift :member_search, search}
    else
      self.all
    end
  end

  def self.email_tags(whom = :all)
    return [] unless self.respond_to?(whom)
    self.send(whom).map { |member| member.email_tag }
  end
end
