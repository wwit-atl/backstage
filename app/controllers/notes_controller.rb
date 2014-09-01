class NotesController < ApplicationController
  authorize_resource

  before_action :load_notable, except: [:destroy]

  def index
    @notes = @notable.notes
  end

  def new
    @notes = @notable.notes.new
  end

  def edit
  end

  def create
    @notes = @notable.notes.new(note_params)
    @notes.member_id = current_member.id
    if @notes.save
      redirect_to @notable, notice: 'Your note was created.'
    else
      render :new
    end
  end

  def update
    @note.member_id = current_member.id
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @notable }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    Note.find(params[:id]).destroy!
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private

  # if we use :resource/:id/notes type paths
  def load_notable
    resource, id= request.path.split('/')[1, 2]
    resource_class = resource.singularize.classify.constantize
    @notable = resource_class.respond_to?(:friendly) ? resource_class.friendly.find(id) : resource_class.find(id)
    @note = Note.find(params[:id]) if params[:id]
  end

  def note_params
    params.require(:note).permit(:content)
  end

  # Otherwise, alternative option:
  # def load_notable
  #   klass = [Member, Skill, Show, Scene, Game, Suggestion].detect { |c| params["#{c.name.underscore}_id"]}
  #   @notable = klass.find(params["#{klass.name.underscore}_id"])
  # end
end
