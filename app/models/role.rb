class Role < ActiveRecord::Base
  has_and_belongs_to_many :members
  belongs_to :resource, :polymorphic => true
  
  scopify

  scope :castable, -> { where(cast: 'true' ) }
  scope :crewable, -> { where(crew: 'true' ) }

  scope :by_name, -> { order(:name) }
  scope :by_member_name, -> { joins(:members).order('members.lastname') }

  default_scope { order(:id) }

  alias_attribute :description, :desc

  def code
    name.upcase
  end
end
