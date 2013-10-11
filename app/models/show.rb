class Show < ActiveRecord::Base
  has_many :shifts, :dependent => :destroy
  has_many :crew_members, :through => :shifts, :source => :member
  has_many :skills, -> { order(:code) }, :through => :shifts
  has_many :scenes, -> { order(:position) }, :dependent => :destroy
  has_many :notes, :as => :notable

  has_and_belongs_to_many :actors, class_name: 'Member', join_table: 'actors_shows'

  accepts_nested_attributes_for :scenes, allow_destroy: true
  accepts_nested_attributes_for :shifts, allow_destroy: true

  validates_presence_of :date

  def call_time
    format_time(calltime)
  end

  def show_time
    format_time(showtime)
  end

  def shift(code)
    shifts.where(skill: Skill.class_eval(code.to_s.downcase)).first || Shift.new
  end

  #def cast
  #  shifts.joins(:skill).merge(Skill.castable)
  #end

  #def crew
  #  shifts.joins(:skill).merge(Skill.crewable)
  #end

end
