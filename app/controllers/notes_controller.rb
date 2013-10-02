class NotesController < ApplicationController
  before_action :load_notable

  def index
    @notes = @notable.notes
  end

  def new
    @notes = @notable.notes.new
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

  private

  # if we use :resource/:id/notes type paths
  def load_notable
    resource, id = request.path.split('/')[1, 2]
    @notable = resource.singularize.classify.constantize.find(id)
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
