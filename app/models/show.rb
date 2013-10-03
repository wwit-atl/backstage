class Show < ActiveRecord::Base
  has_and_belongs_to_many :members

  has_many :notes, :as => :notable
  has_many :scenes, -> { order(:position) }, :dependent => :destroy

  accepts_nested_attributes_for :scenes, allow_destroy: true

  validates_presence_of :date
end
