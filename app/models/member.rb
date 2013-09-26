class Member < ActiveRecord::Base
  include Authority::UserAbilities

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  rolify

  has_many :notes, :as => :notable

  has_many :phones, dependent: :destroy
  accepts_nested_attributes_for :phones, allow_destroy: true

  has_and_belongs_to_many :skills

  validates_presence_of :username, :firstname, :lastname, :email
  validates_uniqueness_of :username, :email

  def fullname
    [ firstname, lastname ].map{ |n| n.capitalize }.join(' ')
  end
  alias :name :fullname
end
