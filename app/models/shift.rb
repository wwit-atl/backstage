class Shift < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :show
  belongs_to :skill
  belongs_to :member

  #validates_presence_of :show_id, :on => :create

  scope :with_skill, ->(code) { joins(:skill).where(skills: {code: code.to_s.upcase}).readonly(false).first }
  scope :for_month,  ->(date) { joins(:show).where('shows.date >= ? AND date <= ?', date.beginning_of_month, date.end_of_month) }

  scope :by_show,           -> { joins(:show).order('shows.date') }
  scope :by_skill_priority, -> { joins(:skill).order('skills.priority').readonly(false) }
  scope :by_skill,          -> { by_show.by_skill_priority }
  scope :by_member,         -> { by_show.joins(:member).order(['members.lastname', 'members.firstname']) }

  scope :recent, -> { joins(:show).where('shows.date > ?', Date.today - 30.days) }

  def text
    text = "#{show.date} [#{show.dow}]"
    text + " - #{skill.name}" unless skill.nil?
  end

end
