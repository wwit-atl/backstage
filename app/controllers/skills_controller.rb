class SkillsController < ApplicationController
  authorize_resource

  before_action :set_skill, except: [ :index, :new, :create, :reposition ]

  # GET /skills
  # GET /skills.json
  def index
    @skills = Skill.order(:priority, :code)
  end

  # GET /skills/new
  def new
    @skill = Skill.new
  end

  def show
  end

  # GET /skills/1/edit
  def edit
  end

  # POST /skills
  # POST /skills.json
  def create
    @skill = Skill.new(skill_params)

    respond_to do |format|
      if @skill.save
        format.html { redirect_to skills_url, notice: 'Skill was successfully created.' }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /skills/1
  # PATCH/PUT /skills/1.json
  def update
    respond_to do |format|
      if @skill.update(skill_params)
        format.html { redirect_to skills_url, notice: 'Skill was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /skills/1
  # DELETE /skills/1.json
  def destroy
    @skill.destroy
    respond_to do |format|
      format.html { redirect_to skills_url }
      format.json { head :no_content }
    end
  end

  def reposition
    params[:skill].each_with_index do |id, index|
      skill = Skill.find(id)
      skill.update_attribute(:priority, index) if skill
    end
    render nothing: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skill
      @skill = Skill.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def skill_params
      params.require(:skill).permit(:code, :name, :description, :training, :autocrew, :ranked)
    end

end
