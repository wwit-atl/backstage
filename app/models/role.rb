class Role < ActiveRecord::Base
  has_and_belongs_to_many :members, :join_table => :members_roles
  belongs_to :resource, :polymorphic => true
  
  scopify

  scope :castable, -> { where(cast: 'true' ) }
  scope :crewable, -> { where(crew: 'true' ) }

  def title
    %w( isp ).include?(name) ? name.upcase : name.titleize
  end
end
