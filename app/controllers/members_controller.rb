class MembersController < ApplicationController
  authorize_resource

  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_action :get_phone_types, only: [:new, :edit, :create, :update]
  before_action :total_skills, only: [:new, :edit, :create, :update]
  skip_before_action :authenticate_member!, only: [:public_profile]

  def public_profile
    # TODO: This is where the member's public profile will be shown... not yet implemented.
    redirect_to members_path
  end

  def admin
    admin_only!
  end

  # GET /members
  # GET /members.json
  def index
    @members = Member.search(params[:search]).by_name.paginate(:page => params[:page], :per_page => 30)
    respond_to do |format|
      format.html
      format.js { render :layout => false }
      format.json { render json: @members, only: [ :lastname, :firstname, :email ] }
    end
  end

  def show
    @shows = @member.shows.recent.by_date
    @shifts = @member.shifts.recent.by_show
    @skills = @member.skills
    @conflicts = @member.conflicts.current

    @notable = @member
    @notes = @notable.notes
    @note = Note.new
  end

  def roles
    admin_only!
    @roles = Role.all
  end

  # GET /members/new
  def new
    @member = Member.new
    # We want at least one new phone number entry to be displayed in the form
    @member.phones.new
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        #format.html { redirect_to @member, notice: 'Member was successfully created.' }
        format.html { redirect_to members_path, notice: 'Member was successfully created.' }
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
    if member_params[:password].blank?
      member_params.delete(:password)
      member_params.delete(:password_confirmation)
    end

    # https://github.com/plataformatec/devise/wiki/How-To%3a-Allow-users-to-edit-their-account-without-providing-a-password
    successfully_updated = needs_password?(@member, member_params) ? @member.update(member_params) : @member.update_without_password(member_params)

    respond_to do |format|
      if successfully_updated
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
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
      format.html { redirect_to members_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_member
    if params[:id].nil?
      redirect_to members_url unless current_member
      @member = current_member
    else
      @member = Member.find(params[:id])
    end
  end

  def total_skills
    @total_skills ||= Skill.all
  end

  def get_phone_types
    @phone_types ||= Phone.ntypes
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def member_params
    params.required(:member).permit(
        :firstname, :lastname, :email, :sex, :dob, :active,
        :password, :password_confirmation,
        skill_ids: [], role_ids: [],
        phones_attributes: [:id, :ntype, :number, :_destroy],
    )
  end

  def needs_password?(member, params)
    params[:password].present?
  end
end
