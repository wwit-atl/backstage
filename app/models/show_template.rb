class ShowTemplate < ActiveRecord::Base
  has_and_belongs_to_many :skills

  def day
    Date::DAYNAMES[dow]
  end
end
