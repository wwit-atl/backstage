class Shift < ActiveRecord::Base
  belongs_to :show
  belongs_to :skill
  belongs_to :member

  before_save do
    self.skill ||= Skill.where(code: 'CAST').first
  end

  validates_presence_of :show_id

  scope :with_skill, lambda { |code|
    includes(:skill).where(skills: {code: code.upcase}).references(:skill)
  }

end
