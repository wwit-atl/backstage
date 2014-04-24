class ShiftsController < ApplicationController
  authorize_resource

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    sort = params[:sort] ||= :show
    case sort.to_sym
      when :skill then @shifts = Shift.for_month(@date).by_show.by_skill_priority
      when :member then @shifts = Shift.for_month(@date).by_member
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

  def schedule
    unauthorized unless can? :schedule, Shift

    date = Date.parse(params[:date] || Date.today.to_s)

    # First, lock all existing conflicts
    Conflict.for_month(date.month).find_each(&:lock!)

    # Now schedule shifts
    @exceptions = Shift.schedule(date)
    flash.notice = "Auto Schedule completed successfully for #{date.strftime('%B, %Y')}" if @exceptions.empty?

    respond_to do |format|
      format.js { render :layout => false }
      format.html { redirect_to members_schedule_path(date: date) }
    end
  end

  def publish
    date = Date.parse(params[:date] || Date.today.to_s)
    Shift.hidden.for_month(date).update_all(hidden: false)

    respond_to do |format|
      format.js { render :layout => false }
      format.html { redirect_to members_schedule_path(date: date) }
    end
  end

end
