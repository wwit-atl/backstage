class Shift < ActiveRecord::Base
  can_be_scheduled

  belongs_to :show
  belongs_to :skill
  belongs_to :member

  validates_presence_of :show_id

  scope :with_skill, lambda { |code| joins(:skill).where(skills: {code: code.to_s.upcase}) }
  scope :by_skill, -> { joins(:skill).order('skills.code') }
end
