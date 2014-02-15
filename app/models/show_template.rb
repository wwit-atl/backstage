class ShowTemplate < ActiveRecord::Base
  can_create_shows

  has_and_belongs_to_many :skills
  belongs_to :group, class_name: 'Role'

  def day
    Date::DAYNAMES[dow]
  end
end
