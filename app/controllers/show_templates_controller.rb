class ShowTemplatesController < ApplicationController
  before_action :set_show_template, only: [:edit, :update, :destroy]
  before_action :set_days_of_week
  before_action :set_skills, only: [:edit, :update]

  # GET /show_templates
  # GET /show_templates.json
  def index
    @show_templates = ShowTemplate.order(:dow, :showtime)
  end

  # GET /show_templates/new
  def new
    @show_template = ShowTemplate.new
  end

  # GET /show_templates/1/edit
  def edit
  end

  # POST /show_templates
  # POST /show_templates.json
  def create
    @show_template = ShowTemplate.new(show_template_params)

    respond_to do |format|
      if @show_template.save
        format.html { redirect_to show_templates_url, notice: 'Show template was successfully created.' }
        format.json { render action: 'show', status: :created, location: @show_template }
      else
        format.html { render action: 'new' }
        format.json { render json: @show_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /show_templates/1
  # PATCH/PUT /show_templates/1.json
  def update
    respond_to do |format|
      if @show_template.update(show_template_params)
        format.html { redirect_to show_templates_url, notice: 'Show template was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @show_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /show_templates/1
  # DELETE /show_templates/1.json
  def destroy
    @show_template.destroy
    respond_to do |format|
      format.html { redirect_to show_templates_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_days_of_week
      @days_of_week = Date::DAYNAMES.each_with_index
    end

    def set_skills
      @skills = Skill.where(category: 'Shift')
    end

    def set_show_template
      @show_template = ShowTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def show_template_params
      params.require(:show_template).permit(:name, :dow, :showtime, :calltime, skill_ids: [])
    end
end
