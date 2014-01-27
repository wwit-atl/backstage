class Role < ActiveRecord::Base
  has_and_belongs_to_many :members
  belongs_to :resource, :polymorphic => true
  
  scopify

  scope :by_name, -> { order(:name) }
  scope :castable, -> { where(cast: 'true' ) }
  scope :crewable, -> { where(crew: 'true' ) }
  scope :by_member_name, -> { joins(:members).order('members.lastname') }

  alias_attribute :description, :desc

  def title
    %w( isp ).include?(name) ? name.upcase : name.titleize
  end

  def code
    name.upcase
  end
end
