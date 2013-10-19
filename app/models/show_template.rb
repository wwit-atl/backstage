class ShowTemplate < ActiveRecord::Base
  can_create_shows

  has_and_belongs_to_many :skills

  def day
    Date::DAYNAMES[dow]
  end
end
