class Ability
  include CanCan::Ability

  def initialize(member)
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    member ||= Member.new # guest user (not logged in)

    alias_action :create, :read, :update, :destroy, :to => :crud

    # Guest can't do anything here
    return if member.new_record?

    if member.has_role?(:admin)
      can :manage, :all
    elsif member.has_role?(:management)
      can :manage, [ Member, Show, Message, Note ]
      can :read, [ Role, Skill, Conflict ]
      cannot [:generate, :destroy], Show
    end

    can :read, [ Member, Show, Note ] if member.company_member?

    # If we ever want to give company members the ability to add and manage notes they create:
    # can :create, Note if member.company_member?
    # can [:edit, :update, :destroy], Note, member_id: member.id

    can [:edit, :update, :cast, :casting_announcement], Show, mc_id: member.id
    can [:read, :edit, :update, :cast_list], Member, id: member.id
    can [:crud, :manage_conflicts, :set_conflicts, :get_conflicts], Conflict, member_id: member.id

    can [:edit, :update, :destroy], Message, sender_id: member.id, approver_id: nil, sent_at: nil
    can :create, Message, member.company_member? => :true
    can :read, Message, sender_id: member.id

    can :read, Message do |message|
      message.members.exists?(member.id)
    end
  end
end
