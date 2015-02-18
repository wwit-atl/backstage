class Api::V1::MembersController < ApplicationController
  respond_to :json
  skip_authorization_check

  def conflicts
    member = Member.find(params[:member_id])

    unauthorized and return unless can? :read, member
    # raise CanCan::AccessDenied unless can? :read, member

    date = Show.find(params[:for_show]).try(:date) if params[:for_show]
    respond_with date.nil? ? member.conflicts.ids : { status: member.conflict?(date) }
  end

  private

  def unauthorized
    respond_with( { :status => :forbidden }, status: 403 )
  end
end
