class Conflict < ActiveRecord::Base
  belongs_to :member

  scope :by_date, -> { order(:date) }
end
