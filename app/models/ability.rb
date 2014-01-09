class Ability
  include CanCan::Ability

  def initialize(member)
    member ||= Member.new # guest user (not logged in)

    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    if member.has_role? :admin
      can :manage, :all
    else
      can :read, :all
      can :update, Member, id => member.id
    end

  end
end
