class Show < ActiveRecord::Base
  #has_and_belongs_to_many :members
  #has_and_belongs_to_many :skills

  has_many :shifts, :dependent => :destroy

  has_many :members, :through => :shifts
  has_many :skills,  :through => :shifts

  has_many :scenes, -> { order(:position) }, :dependent => :destroy
  has_many :notes, :as => :notable

  accepts_nested_attributes_for :scenes, allow_destroy: true
  accepts_nested_attributes_for :shifts, allow_destroy: true

  validates_presence_of :date

  def call_time
    calltime.strftime('%l:%M %P')
  end

  def show_time
    showtime.strftime('%l:%M %P')
  end

  def shift(code)
    #skill = Skill.where(code: code.upcase).first
    #raise NoMethodError, "No Skill matches #{code}" if skill.nil?
    #shifts.where(skill: skill).first || Shift.none

    shifts.where(skill: Skill.class_eval(code.to_s.downcase)).first || Shift.new
  end

end
