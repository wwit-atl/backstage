class ConflictsController < ApplicationController
  before_action :get_member, :get_config, except: [:index]

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
    @conflicts = @member.conflicts.current
    respond_to do |format|
      format.html
      format.json { render json: @member.conflicts }
      format.js   { render json: @member.conflicts }
    end
  end

  def get_conflicts
    respond_to do |format|
      format.html
      format.json { render json: @member.conflicts }
      format.js   { render json: @member.conflicts }
    end
  end

  def set_conflicts
    # TODO: Need to check authentication here!

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
        flash[:error] = 'Oops, there was a problem updating conflicts'
      end
    end
    render action: 'manage'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    #def set_conflict
    #  @conflict = Conflict.find(params[:id])
    #end

    def get_config
      @max_conflicts = Konfig.member_max_conflicts
    end

    def get_member
      @member = Member.find(params[:member_id]) || Member.none
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conflict_params
      params.require(:conflicts).permit(:date, :member_id)
    end
end
