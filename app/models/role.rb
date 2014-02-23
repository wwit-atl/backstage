class Role < ActiveRecord::Base
  has_and_belongs_to_many :members
  belongs_to :resource, :polymorphic => true
  
  scopify

  scope :castable, -> { where(cast: 'true' ) }
  scope :crewable, -> { where(crew: 'true' ) }

  scope :company_member, -> { where(cm:   'true' ) }
  scope :auto_schedule,  -> { where(schedule: 'true' ) }

  scope :by_name, -> { order(:name) }
  scope :by_member_name, -> { joins(:members).order('members.lastname') }

  default_scope { order(:id) }

  alias_attribute :description, :desc

  def self.viewable(member)
    case
      when (member.has_role?(:super) and member.has_role?(:admin)) then Role.where.not(:name => :super)
      else Role.where.not(:name => [:super, :admin])
    end
  end

  def code
    name.upcase.to_s
  end
end
