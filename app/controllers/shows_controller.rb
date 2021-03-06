class ShowsController < ApplicationController
  authorize_resource

  before_action :set_show, only: [:show, :edit, :update, :destroy]
  before_action :set_supporting, except: [ :schedule ]
  before_action :set_exceptions, only: [ :index, :schedule ]

  # GET /shows
  # GET /shows.json
  def index
    session[:date_params] = params[:date]
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
    @show.tickets = {}
    @show.showtime = '8:00pm'
    @show.calltime = '6:30pm'
  end

  # GET /shows/1/edit
  def edit
    @show.capacity ||= Konfig.default_show_capacity
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
      format.html { redirect_back_to shows_url }
      format.json { head :no_content }
    end
  end

  def create_shows
    unauthorized unless can? :create, Show
    date = ( Date.parse(params[:date]) || Date.today )
    Audit.logger :show, "Begin create shows for #{date.strftime('%B %Y')}"
    ShowTemplate.create_shows_for(date.month, date.year)
    flash.notice = "Created shows for #{date.strftime('%B %Y')}"
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def casting_announcement
    return unless params[:show_id]

    @show = Show.find(params[:show_id])
    unauthorized && return unless can? :cast, @show

    @show.casting_sent_at = Time.now

    Audit.logger :show, "Sent casting announcement for #{@show.title}"

    if BackstageMailer.casting_announcement(@show).deliver_later
      @show.save
      redirect_to :back, flash: { success: 'Casting Announcement Sent' }
    else
      redirect_to :back, flash: { error: 'Unable to send email(s)!' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_show
      @show = Show.find(params[:id]) rescue nil
      return if @show.nil?

      @actors = @show.actors.by_name
      @shifts = @show.shifts.by_skill_priority
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def show_params
      # ticket_keys = params[:show][:tickets].try(:keys)
      params.require(:show).permit(
          :name, :date, :showtime, :calltime, :mc_id, :group_id, :capacity, actor_ids: [],
          shifts_attributes: [ :id, :training, :member_id, :skill_id, :_destroy ],
          #scenes_attributes: [
          #    :id, :_destroy, :stage_id, :position, :suggestion,
          #    notes_attributes: [ :id, :content, :_destroy ]
          #]
      ).tap { |whitelist| whitelist[:tickets] = params[:show][:tickets] }
    end

    def set_supporting
      @stages   = Stage.all
      @skills   = Skill.all.by_code
      @crewable = Member.crewable.by_name.to_a.uniq
      @castable = Member.castable.by_name.to_a.uniq
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
