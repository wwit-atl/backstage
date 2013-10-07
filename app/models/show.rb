class Show < ActiveRecord::Base
  has_and_belongs_to_many :members
  has_and_belongs_to_many :skills

  has_many :notes, :as => :notable
  has_many :scenes, -> { order(:position) }, :dependent => :destroy

  accepts_nested_attributes_for :scenes, allow_destroy: true

  validates_presence_of :date

  def call_time
    calltime.strftime('%l:%M %P')
  end

  def show_time
    showtime.strftime('%l:%M %P')
  end
end
