class Ability
  include CanCan::Ability

  def initialize(member)
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    member ||= Member.new # guest user (not logged in)

    # Guest can't do anything here
    return if member.new_record?

    can :read, [ Member, Show ]
    can :update, Member, :id => member.id
    can [:update, :manage], Conflict, :member_id => member.id

    if member.has_role? :admin
      can :manage, :all
    end

    if member.has_role? :management
      can :manage, [ Member, Show ]
    end

    if member.has_role? :ms
      can :update, Show
    end

  end
end
