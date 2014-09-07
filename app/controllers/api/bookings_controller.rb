class Api::BookingsController < ApplicationController
  def create
    booking_params = params.require(:booking).permit(:timeslot_id, :size)
    Booking.create(booking_params)

    head :ok
  end
end
