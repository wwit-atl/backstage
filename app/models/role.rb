class Role < ActiveRecord::Base
  has_and_belongs_to_many :members
  belongs_to :resource, :polymorphic => true
  
  scopify

  scope :castable, -> { where(cast: 'true' ) }
  scope :crewable, -> { where(crew: 'true' ) }
  scope :by_member_name, -> { joins(:members).order('members.lastname') }

  alias_attribute :code, :name

  def title
    %w( isp ).include?(name) ? name.upcase : name.titleize
  end
end
