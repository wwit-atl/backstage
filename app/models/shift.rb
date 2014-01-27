class Shift < ActiveRecord::Base
  belongs_to :show
  belongs_to :skill
  belongs_to :member

  validates_presence_of :show_id, :on => :create

  scope :with_skill, lambda { |code| joins(:skill).where(skills: {code: code.to_s.upcase}).readonly(false).first }
  scope :by_skill, -> { joins(:skill).order('skills.code') }
  scope :by_show_date, -> { joins(:show).order('shows.date') }
  scope :by_skill_priority, -> { joins(:skill).order('skills.priority').readonly(false) }
  scope :recent, -> { joins(:show).where('shows.date > ?', Date.today - 30.days) }

  def text
    text = "#{show.date} [#{show.dow}]"
    text + " - #{skill.name}" unless skill.nil?
  end

  def member_name
    member.nil? ? 'Nobody Assigned' : link_to(member.name, member_path(member))
  end
end
