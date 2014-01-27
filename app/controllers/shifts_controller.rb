class ShiftsController < ApplicationController
  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    sort = params[:sort] ||= :show
    case sort.to_sym
      when :skill then @shifts = Shift.for_month(@date).by_skill
      when :member then @shifts = Shift.for_month(@date).by_member
      else @shifts = Shift.for_month(@date)
    end
    @sorted_by = sort.to_sym
  end
end
