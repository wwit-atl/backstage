class ConflictsController < ApplicationController
  authorize_resource

  before_action :get_member, :except => [ :index, :lock_conflicts ]
  before_action :get_config, :authorize

  # GET /conflicts
  # GET /conflicts.json
  def index
    admin_only!
    @members = Member.uses_conflicts.by_name.paginate(:page => params[:page], :per_page => 30)
    respond_to do |format|
      format.html
      format.json {}
      format.js   {}
    end
  end

  def manage
    unauthorized unless can? :read, @member
    @conflicts = @member.conflicts
    @date = params[:date] ? Date.parse(params[:date]) : Date.today + 1.month # By default, select next month
    @conflicts_this_month = @conflicts.for_month(@date.month, @date.year)
    @cur_conflicts = @conflicts_this_month.count
  end

  def get_conflicts
    respond_to do |format|
      format.html { render 'public/403' }
      format.json { render json: @member.conflicts }
      format.js   { render json: @member.conflicts }
    end
  end

  def set_conflicts
    @conflict_date = params[:date]
    @conflict = @member.conflicts.for_date(@conflict_date).first

    if @conflict
      @conflict.destroy if current_member.is_admin? or !@conflict.locked?
    else
      conflict_date = Date.parse(@conflict_date)
      unless Conflict.create( month: conflict_date.month,
                              day:   conflict_date.day,
                              year:  conflict_date.year,
                              member: @member )
        flash[:alert] = 'Oops, there was a problem updating conflicts'
      end
    end

    respond_to do |format|
      format.html { redirect_to manage_member_conflicts_path(@member) }
      format.js {}
    end
  end

  def lock_conflicts
    unauthorized unless can? :manage, Conflict

    Conflict.find_each(&:lock!)
    respond_to do |format|
      format.html { redirect_to conflicts_path, notice: 'All existing conflicts have been locked.' }
      format.js {}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    #def set_conflict
    #  @conflict = Conflict.find(params[:id])
    #end
    def authorize
      authorized?(@member)
    end

    def get_config
      @max_conflicts = Konfig.member_max_conflicts
    end

    def get_member
      @member = Member.friendly.find(params[:member_id]) || Member.none
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conflict_params
      params.require(:conflicts).permit(:date, :member_id)
    end
end
