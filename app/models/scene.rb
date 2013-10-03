class Scene < ActiveRecord::Base
  has_many :notes, :as => :notable
  belongs_to :show
  belongs_to :stage

  acts_as_list :scope => :show
end
