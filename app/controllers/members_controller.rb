class MembersController < ApplicationController
  authorize_resource except: [:public_profile, :admin]
  skip_authorization_check only: [:public_profile, :admin]

  skip_before_action :authenticate_member!, only: [:public_profile, :admin]

  before_action :set_member, only: [:cast_list, :show, :edit, :update, :destroy]
  before_action :get_phone_types, only: [:new, :edit, :create, :update]
  before_action :total_skills, only: [:new, :edit, :create, :update]
  before_action :get_roles, only: [:roles, :new, :edit, :create, :update]

  def public_profile
    # TODO:  This is where the member's public profile will be shown... not yet implemented.
  end

  def admin
    unauthorized && return unless current_member and current_member.superuser?

    if current_member.is_admin?
      Audit.logger :system, 'Is no longer an Administrator.'
      current_member.remove_role :admin
    else
      Audit.logger :system, 'Became an Administrator.'
      current_member.add_role :admin
    end

    respond_to do |format|
      format.html { render :nothing }
      format.js { render :layout => false }
    end
  end

  # GET /members
  # GET /members.json
  def index
    @members = ( can? :manage, Member ) ? Member.all : Member.active.accessible_by(current_ability)
    @members = @members.search(params[:search]) if params[:search]
    @members = @members.by_name.paginate(:page => params[:page], :per_page => 25)
    @member_count = @members.count

    respond_to do |format|
      format.html
      format.js { render :layout => false }
      format.json { render json: @members, only: [ :lastname, :firstname, :email ] }
    end
  end

  def show
    unauthorized unless @member.active? or can? :edit, @member

    @date = params[:date] ? Date.parse(params[:date]) : Date.today

    @shows  = @member.mc_shifts.recent.by_date_desc | @member.shows.recent.by_date_desc
    @shifts = @member.shifts.visible.recent.by_show
    @skills = @member.skills.by_priority
    @conflicts = @member.conflicts.current
    @announcements = Message.for_member(@member).recent.by_created.limit(5)

    @notable = @member
    @notes = @notable.notes
    @note = Note.new

    respond_to do |format|
      format.html {}
      format.js { render :layout => false }
      format.json { render :json => @shifts.map(&:to_json) }
      format.ics do
        calendar = Icalendar::Calendar.new
        @shifts.each { |event| calendar.add_event(event.to_ics) }
        calendar.publish
        render :text => calendar.to_ical
      end
    end
  end

  def cast_list
    @shows = @member.shows.by_date_desc
  end

  def roles
    unauthorized unless can? :read, Role
  end

  def schedule
    @exceptions = session[:exceptions] && session.delete(:exceptions) if session[:exceptions]

    @members = Member.schedulable.by_name_last
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @shifts = Shift.for_month(@date).by_show
  end

  # GET /members/new
  def new
    @member = Member.new
    # We want at least one new phone number entry to be displayed in the form
    #@member.phones.new
    #@member.addresses.new
  end

  # GET /members/1/edit
  def edit
    unauthorized unless can? :edit, @member
    #@member.phones.new unless @member.phones.any?
    #@member.addresses.new unless @member.addresses.any?
  end

  # POST /members
  # POST /members.json
  def create
    update_params = can?(:admin, Member) ? admin_params : member_params

    @member = Member.new(update_params)

    respond_to do |format|
      if @member.save
        #format.html { redirect_to @member, notice: 'Member was successfully created.' }
        format.html { redirect_back_to members_path, notice: 'Member was successfully created.' }
        format.json { render action: 'show', status: :created, location: @member }
      else
        format.html { render action: 'new' }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    update_params = can?(:admin, @member) ? admin_params : member_params

    if update_params[:password].blank?
      update_params.delete(:password)
      update_params.delete(:password_confirmation)
    end

    # https://github.com/plataformatec/devise/wiki/How-To%3a-Allow-users-to-edit-their-account-without-providing-a-password
    successfully_updated = needs_password?(update_params) ? @member.update(update_params) : @member.update_without_password(update_params)

    respond_to do |format|
      if successfully_updated
        format.html { redirect_back_to @member, notice: 'Member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_back_to members_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_member
    if params[:id].nil? and params[:member_id].nil?
      redirect_to members_url unless current_member
      @member = current_member
    else
      @member ||= Member.friendly.find(params[:id]) if params[:id]
      @member ||= Member.friendly.find(params[:member_id]) if params[:member_id]
    end
  end

  def total_skills
    @total_skills ||= Skill.all
  end

  def get_phone_types
    @phone_types ||= Phone.ntypes
  end

  def get_roles
    @roles = Role.viewable(current_member)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def member_params
    params.required(:member).permit(
        :firstname, :lastname, :email, :sex, :dob, :active, :avatar,
        :password, :password_confirmation,
        phones_attributes: [:id, :ntype, :number, :_destroy],
        addresses_attributes: [:id, :atype, :street1, :street2, :city, :state, :zip, :_destroy ],
    )
  end

  def admin_params
    params.required(:member).permit!
  end

  def needs_password?(params)
    params[:password].present?
  end
end
