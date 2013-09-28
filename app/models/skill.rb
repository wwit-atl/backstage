class Skill < ActiveRecord::Base
  resourcify

  has_and_belongs_to_many :members
  has_many :notes, :as => :notable

  def self.categories
    %w(Shift Performance)
  end
end
