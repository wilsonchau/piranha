class Booking < ActiveRecord::Base
  belongs_to :timeslot

  validate :booked

  private
  def booked
    errors.add(:timeslot, "cannot accomodate booking") unless timeslot.book(self.size)
  end
end
