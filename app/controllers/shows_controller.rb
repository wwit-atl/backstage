class ShowsController < ApplicationController
  authorize_resource

  before_action :set_show, only: [:show, :edit, :update, :destroy]
  before_action :set_supporting, except: [ :schedule ]
  before_action :set_exceptions, only: [ :index, :schedule ]

  # GET /shows
  # GET /shows.json
  def index
  end

  # GET /shows/1
  # GET /shows/1.json
  def show
    @notable = @show
    @notes = @notable.notes
    @note = Note.new
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

  def schedule
    admin_only!
    @exceptions = Show.schedule
    flash.notice = 'Auto Schedule completed successfully' if @exceptions.empty?
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def create_shows
    admin_only!
    date = ( Date.parse(params[:date]) || Date.today )
    logger.debug "Creating shows for #{date}"
    ShowTemplate.create_shows_for(date.month, date.year)
    flash.notice = "Created shows for #{date.strftime('%B %Y')}"
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_show
      @show = Show.find(params[:id])
      @actors = @show.actors.by_name
      @shifts = @show.shifts.by_skill_priority
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def show_params
      params.require(:show).permit(
          :name, :date, :showtime, :calltime, :mc_id, :group_id,
          actor_ids: [],
          shifts_attributes: [ :id, :member_id, :skill_id, :_destroy ],
          #scenes_attributes: [
          #    :id, :_destroy, :stage_id, :position, :suggestion,
          #    notes_attributes: [ :id, :content, :_destroy ]
          #]
      )
    end

    def set_supporting
      @stages   = Stage.all
      @skills   = Skill.all
      @crewable = Member.crewable.by_name
      @castable = Member.castable.by_name
      @groups   = Role.castable
      @mcs = Member.active.has_role(:mc)
    end

    def set_exceptions
      @exceptions = []
      @date = params[:date] ? Date.parse(params[:date]) : Date.today
      @date_string = @date.strftime("%B %Y")
      @shows = Show.for_month(@date).order(:date, 'showtime ASC')
    end

end
