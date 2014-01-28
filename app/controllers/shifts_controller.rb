class ShiftsController < ApplicationController
  authorize_resource

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    sort = params[:sort] ||= :show
    case sort.to_sym
      when :skill then @shifts = Shift.for_month(@date).by_show.by_skill_priority
      when :member then @shifts = Shift.for_month(@date).by_show.by_member
      else @shifts = Shift.for_month(@date).by_skill_priority.by_show
    end
    @sorted_by = sort.to_sym
    @members   = Member.active.by_name
  end

  def update
    @shift = Shift.find(params[:id])
    respond_to do |format|
      if @shift.update(params.require(:shift).permit(:member_id))
        format.html { redirect_to shifts_path, notice: 'Shift was successfully updated.' }
        format.json { head :no_content }
        format.js { render :layout => false }
      else
        format.html { render action: 'index', alert: 'Could not safe record' }
        format.json { render json: @shift.errors, status: :unprocessable_entity }
      end
    end
  end

end
