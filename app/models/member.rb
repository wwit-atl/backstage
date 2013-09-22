class Member < ActiveRecord::Base
  has_many :phones, dependent: :destroy
  accepts_nested_attributes_for :phones, allow_destroy: true
  validates_presence_of :username, :firstname, :lastname, :email
  validates_uniqueness_of :username, :email
end
