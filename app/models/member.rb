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

  scope :castable, -> { joins(:roles).where('roles.cast' => :true) }
  scope :crewable, -> { joins(:roles).where('roles.crew' => :true) }

  scope :has_role,  lambda { |role| joins(:roles).where('roles.name' => role) }
  scope :has_skill, lambda { |skill| joins(:skills).where('skills.code' => skill.upcase) }

  default_scope -> { order(:lastname) }

  def fullname
    [ firstname, lastname ].map{ |n| n.capitalize }.join(' ')
  end
  alias :name :fullname
end
