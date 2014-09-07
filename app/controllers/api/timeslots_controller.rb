class Api::TimeslotsController < ApplicationController
  def index
    timeslot_params = params.permit(:date)
    date = Date.parse(timeslot_params[:date])
    render json: Timeslot.all_during_date(date).map(&:as_json)
  end

  def create
    timeslot_params = params.require(:timeslot).permit(:start_time, :duration)
    render json: Timeslot.create(timeslot_params).as_json
  end
end
