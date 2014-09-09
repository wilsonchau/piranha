class Booking < ActiveRecord::Base
  belongs_to :timeslot

  before_save :book

  private
  def book
    errors.add(:timeslot, "cannot accomodate booking") unless timeslot.book(self.size)
  end
end
