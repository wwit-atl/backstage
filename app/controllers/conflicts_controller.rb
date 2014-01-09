class ConflictsController < ApplicationController
  before_action :get_member, :get_config, except: [:index]
  before_action :authorize, :except => :index

  # GET /conflicts
  # GET /conflicts.json
  def index
    admin_only!
    @members = Member.by_name.paginate(:page => params[:page], :per_page => 30)
    respond_to do |format|
      format.html
      format.json { render json: @member.conflicts }
      format.js   { render json: @member.conflicts }
    end
  end

  def manage
    unauthorized unless can? :read, @member

    @conflicts = @member.conflicts

    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @date_string = @date.strftime("%B %Y")

    @conflicts_this_month = @conflicts.for_month(@date.month, @date.year)
    @conflict_count = @conflicts_this_month.count
  end

  def get_conflicts
    respond_to do |format|
      format.html { render 'public/403' }
      format.json { render json: @member.conflicts }
      format.js   { render json: @member.conflicts }
    end
  end

  def set_conflicts
    @conflict = @member.conflicts.for_date(params[:date]).first

    if @conflict
      @conflict.destroy
    else
      conflict_date = Date.parse(params[:date])
      unless Conflict.create(
          month: conflict_date.month,
          day:   conflict_date.day,
          year:  conflict_date.year,
          member: @member
      )
        flash[:alert] = 'Oops, there was a problem updating conflicts'
      end
    end
    flash[:notice] = 'HEY!'
    redirect_to manage_member_conflicts_path(@member)
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
      @max_conflicts = Konfig.member_max_conflicts.to_i
    end

    def get_member
      @member = Member.find(params[:member_id]) || Member.none
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conflict_params
      params.require(:conflicts).permit(:date, :member_id)
    end
end
