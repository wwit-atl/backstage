class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  rolify

  has_many :notes, :as => :notable
  has_many :shifts
  has_many :shows, :through => :shifts

  has_many :phones, dependent: :destroy
  accepts_nested_attributes_for :phones, allow_destroy: true

  has_and_belongs_to_many :skills

  validates_presence_of :email, :firstname, :lastname
  validates_uniqueness_of :email

  scope :castable, -> { includes(:skills).where(skills: { category: 'cast' }) }
  scope :crewable, -> { includes(:skills).where(skills: { category: 'crew' }) }

  scope :has_role,  lambda { |role| includes(:roles).where(roles: {name: role}) }
  scope :has_skill, lambda { |skill| includes(:skills).where(skills: {code: skill.upcase}) }

  scope :by_name, -> { order(:lastname) }

  attr_accessor :cast

  def fullname
    [ firstname, lastname ].map{ |n| n.capitalize }.join(' ')
  end
  alias :name :fullname

end
