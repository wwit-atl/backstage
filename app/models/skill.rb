class Skill < ActiveRecord::Base
  resourcify
  acts_as_list :column => :priority

  has_and_belongs_to_many :members
  has_many :notes, :as => :notable
  has_many :shows, :through => :shifts

  validates_presence_of :code, :name

  before_save do
    code.upcase!
  end

  scope :with_code,   -> (code) { where(code: code.to_s.upcase) }
  scope :by_code,     -> { order(:code) }
  scope :by_priority, -> { order(:priority) }

  default_scope by_priority

  def requires_training?
    self.training
  end

end
