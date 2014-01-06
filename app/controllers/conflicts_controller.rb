class ConflictsController < ApplicationController
  before_action :get_member, :get_config

  # GET /conflicts
  # GET /conflicts.json
  def index
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
    #redirect_to manage_member_conflicts_path(@member)
    render action: 'manage'
  end

  # POST /conflicts
  # POST /conflicts.json
  #def create
  #  @conflict = Conflict.new(conflict_params)
  #
  #  respond_to do |format|
  #    if @conflict.save
  #      format.html { redirect_to @conflict, notice: 'Conflict was successfully created.' }
  #      format.json { render action: 'show', status: :created, location: @conflict }
  #    else
  #      format.html { render action: 'new' }
  #      format.json { render json: @conflict.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # PATCH/PUT /conflicts/1
  # PATCH/PUT /conflicts/1.json
  #def update
  #  respond_to do |format|
  #    if @conflict.update(conflict_params)
  #      format.html { redirect_to @conflict, notice: 'Conflict was successfully updated.' }
  #      format.json { head :no_content }
  #    else
  #      format.html { render action: 'edit' }
  #      format.json { render json: @conflict.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /conflicts/1
  # DELETE /conflicts/1.json
  #def destroy
  #  @conflict.destroy
  #  respond_to do |format|
  #    format.html { redirect_to conflicts_url }
  #    format.json { head :no_content }
  #  end
  #end

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
