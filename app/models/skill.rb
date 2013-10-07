class Skill < ActiveRecord::Base
  resourcify

  has_and_belongs_to_many :members
  has_many :notes, :as => :notable

  validates_presence_of :code, :name

  scope :crew, -> { where(category: 'Shift') }

  def self.categories
    %w(Shift Performance)
  end
end
