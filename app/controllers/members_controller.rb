class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_action :get_phone_types, only: [:new, :edit, :update]

  def dashboard
    @member = current_member
    @skills = @member.skills
  end

  def admin
    admin_only!
  end

  # GET /members
  # GET /members.json
  def index
    @members = Member.order(lastname: :asc)
  end

  # GET /members/1
  # GET /members/1.json
  def show
    @member = Member.find(params[:id])
    @shows = @member.shows.recent.by_date
    @shifts = @member.shifts.recent.by_show_date
    @skills = @member.skills
    @conflicts = @member.conflicts.current

    @notable = @member
    @notes = @notable.notes
    @note = Note.new
  end

  # GET /members/new
  def new
    @member = Member.new
    # We want at least one new phone number entry to be displayed in the form
    @member.phones.new
  end

  # GET /members/1/edit
  def edit
    @current_member = current_member
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(
        current_member.is_admin? ? admin_member_params : member_params
    )

    respond_to do |format|
      if @member.save
        #format.html { redirect_to @member, notice: 'Member was successfully created.' }
        format.html { redirect_to action: 'index', notice: 'Member was successfully created.' }
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
    strong_params = current_member.is_admin? ? admin_member_params : member_params
    respond_to do |format|
      if @member.update_attributes(strong_params)
        format.html { redirect_to action: 'index', notice: 'Member was successfully updated.' }
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
    @member = Member.find(params[:id])
  end

  def get_phone_types
    @phone_types = Phone.ntypes
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_member_params
    params.required(:member).permit(
        :firstname, :lastname, :email,
        :password, :password_confirmation,
        skill_ids: [], role_ids: [],
        phones_attributes: [:id, :ntype, :number, :_destroy],
    )
  end

  def member_params
    params.required(:member).permit(
        :firstname, :lastname,
        :password, :password_confirmation, :current_password,
        phones_attributes: [:id, :ntype, :number, :_destroy],
    )
  end
end
