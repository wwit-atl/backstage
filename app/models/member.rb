class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  rolify

  has_many :notes, :as => :notable

  has_many :phones, dependent: :destroy
  accepts_nested_attributes_for :phones, allow_destroy: true

  has_and_belongs_to_many :skills
  has_and_belongs_to_many :shows

  validates_presence_of :email, :firstname, :lastname
  validates_uniqueness_of :email

  def fullname
    [ firstname, lastname ].map{ |n| n.capitalize }.join(' ')
  end
  alias :name :fullname
end
