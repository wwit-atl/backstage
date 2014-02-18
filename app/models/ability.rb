class Ability
  include CanCan::Ability

  def initialize(member)
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    member ||= Member.new # guest user (not logged in)

    # Guest can't do anything here
    return if member.new_record?

    can :manage, :all if member.has_role? :admin

    can :manage, [ Member, Show, Message, Note ] if member.has_role? :management
    can :read,   [ Member, Show, Note ] if member.company_member?

    cannot :read, [ Member, Show ] if member.has_role? :volunteer

    #can :create, Note if member.company_member?
    #can [:read, :update, :destroy], Note, member_id: member.id

    can [:edit, :update, :cast], Show, mc_id: member.id

    can [:read, :edit, :update], Member, id: member.id
    can :manage, Conflict, member_id: member.id

    can [:edit, :update, :destroy], Message, sender_id: member.id, approver_id: nil, sent_at: nil
    can :create, Message, member.company_member? => :true
    can :read, Message, sender_id: member.id
    can :read, Message do |message|
      message.members.exists?(member.id)
    end
  end
end
