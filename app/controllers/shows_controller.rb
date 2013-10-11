class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :edit, :update, :destroy]
  before_action :set_supporting

  # GET /shows
  # GET /shows.json
  def index
    @shows = Show.all
  end

  # GET /shows/1
  # GET /shows/1.json
  def show
  end

  # GET /shows/new
  def new
    @show = Show.new
    @show.showtime = '8:00pm'
    @show.calltime = '6:30pm'
  end

  # GET /shows/1/edit
  def edit
  end

  # POST /shows
  # POST /shows.json
  def create
    @show = Show.new(show_params)

    respond_to do |format|
      if @show.save
        format.html { redirect_to @show, notice: 'Show was successfully created.' }
        format.json { render action: 'show', status: :created, location: @show }
      else
        format.html { render action: 'new' }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shows/1
  # PATCH/PUT /shows/1.json
  def update
    respond_to do |format|
      if @show.update(show_params)
        format.html { redirect_to @show, notice: 'Show was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shows/1
  # DELETE /shows/1.json
  def destroy
    @show.destroy
    respond_to do |format|
      format.html { redirect_to shows_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_show
      @show = Show.find(params[:id])
      @cast = @show.actors.by_name
      @crew = @show.shifts.by_skill
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def show_params
      params.require(:show).permit(
          :date, :showtime, :calltime,
          actor_ids: [],
          shifts_attributes: [ :id, :member_id, :skill_id, :_destroy ],
          scenes_attributes: [ :id, :position, :suggestion, :_destroy ],
      )
    end

    def set_supporting
      @stages           = Stage.all
      @skills_crewable  = Skill.crewable
      @members_castable = Role.castable
      @members_crewable = Member.crewable
    end
end
