class Booking < ActiveRecord::Base
  belongs_to :timeslot

  private
  def valid_booking
    # check to see if we have available boat for booking
  end
end
