class BookingsController < ApplicationController
  def create
    booking_params = params.permit(:timeslot_id, :size)
    Booking.create(booking_params)
  end
end
