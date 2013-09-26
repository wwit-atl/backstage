class Note < ActiveRecord::Base
  belongs_to :notable, polymorphic: true
  belongs_to :member,  :class_name => 'Member', :foreign_key => 'notable_id'
  validates_presence_of :content
end
