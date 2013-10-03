class Show < ActiveRecord::Base
  has_and_belongs_to_many :members
  has_many :notes, :as => :notable

  validates_presence_of :date
end
