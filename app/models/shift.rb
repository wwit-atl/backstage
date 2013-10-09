class Shift < ActiveRecord::Base
  belongs_to :show
  belongs_to :skill
  belongs_to :member

  validates_presence_of :show_id, :skill_id
  validates_numericality_of :show_id, :skill_id

  scope :with_code, lambda { |code| joins(:skill).where('skills.code' => code.upcase) }

  # We need this to assign members though Shows
  def member=(member)
    member.try(:id) || return
    self.member_id = member.id
    self.save
  end
end
