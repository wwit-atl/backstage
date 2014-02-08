class Ability
  include CanCan::Ability

  def initialize(member)
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    member ||= Member.new # guest user (not logged in)

    # Guest can't do anything here
    return if member.new_record?

    can :manage, :all if member.has_role? :admin

    can :manage, [ Member, Show, Message ] if member.has_role? :management
    can :read, [ Member, Show, Message ] if member.company_member?

    can [:edit, :update, :cast], Show if member.has_role? :mc

    can [:edit, :update], Member, :id => member.id
    can :manage, Conflict, :member_id => member.id

    can :create, Message, member.company_member? => :true
    can [:edit, :update, :destroy], Message, :sender_id => member.id, approver_id: nil, sent_at: nil
  end
end
