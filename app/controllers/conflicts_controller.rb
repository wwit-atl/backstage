class ConflictsController < ApplicationController
  before_action :set_members, only: [:edit, :get_conflicts]

  # GET /conflicts
  # GET /conflicts.json
  def index
    @members = Member.by_name.paginate(:page => params[:page], :per_page => 30)
  end

  # GET /conflicts/1/edit
  def edit
    @selected = @members.first
  end

  def get_conflicts
    @selected = Member.find(params[:conflicts][:member]) || Member.none
    respond_to do |format|
      format.html { render :edit }
      format.json { render json: @selected.conflicts }
    end
  end

  # POST /conflicts
  # POST /conflicts.json
  def create
    @conflict = Conflict.new(conflict_params)

    respond_to do |format|
      if @conflict.save
        format.html { redirect_to @conflict, notice: 'Conflict was successfully created.' }
        format.json { render action: 'show', status: :created, location: @conflict }
      else
        format.html { render action: 'new' }
        format.json { render json: @conflict.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conflicts/1
  # PATCH/PUT /conflicts/1.json
  def update
    respond_to do |format|
      if @conflict.update(conflict_params)
        format.html { redirect_to @conflict, notice: 'Conflict was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @conflict.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conflicts/1
  # DELETE /conflicts/1.json
  def destroy
    @conflict.destroy
    respond_to do |format|
      format.html { redirect_to conflicts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conflict
      @conflict = Conflict.find(params[:id])
    end

    def set_members
      @members = Member.by_name
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conflict_params
      params.require(:conflicts).permit(:date, :member_id)
    end
end
