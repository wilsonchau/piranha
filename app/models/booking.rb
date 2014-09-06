class Booking < ActiveRecord::Base
  belongs_to :timeslot

  validate :timeslot_can_accomodate

  private
  def timeslot_can_accomodate
    timeslot.can_accomodate?(size)
  end
end
