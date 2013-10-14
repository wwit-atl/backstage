class Shift < ActiveRecord::Base
  belongs_to :show
  belongs_to :skill
  belongs_to :member

  before_save do
    self.skill ||= Skill.where(code: 'CAST').first
  end

  validates_presence_of :show_id

  scope :with_skill, lambda { |code|
    includes(:skill).where(skills: {code: code.upcase})
  }

  scope :by_skill, -> { joins(:skill).order('skills.id') }

  scope :cast, -> { includes(:skill).merge(Skill.castable) }
  scope :crew, -> { includes(:skill).merge(Skill.crewable) }

end
