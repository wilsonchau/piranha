class TimeslotsController < ApplicationController
  def index
    timeslot_params = params.permit(:date)
    date = Date.parse(timeslot_params[:date])
    render json: Timeslot.all_during_date(date)
  end

  def create
    timeslot_params = params.permit(:start_time, :duration)
    render json: Timeslot.create(timeslot_params)
  end
end
