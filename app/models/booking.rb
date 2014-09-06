class Booking < ActiveRecord::Base
  belongs_to :timeslot

  validate :timeslot_can_accomodate
  after_save :update_timeslot_availability

  private
  def timeslot_can_accomodate
    timeslot.can_accomodate?(size)
  end

  def update_timeslot_availability
    timeslot.update_availability
  end
end
