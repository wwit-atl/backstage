class Skill < ActiveRecord::Base
  resourcify

  has_and_belongs_to_many :members
  has_many :notes, :as => :notable

  validates_presence_of :code, :name

  def self.categories
    %w(Shift Performance)
  end
end
