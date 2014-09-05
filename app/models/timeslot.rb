class Timeslot < ActiveRecord::Base
  has_many :assignments
  has_many :boats, through: :assignments
  has_many :bookings

  def self.all_during_date(date)
    Timeslot.all.select{|timeslot| Time.at(timeslot.start_time).to_date === date}
  end

  def as_json
    super(include: :boats).merge(availability: availability, customer_count: customer_count)
  end

  def can_accomodate?(party_size)
    # check if we have availability
      # may need to do this check after shuffling people around for bookings to do best fit

    # need to do best fit everytime in case we add new boats or bookings change
    # look at bookings and do best fit
      # hard part

    # update availability if we used biggest boat
  end

  def availability
    boats.map(&:size).max
    # more complicated since biggest boat may have people on it already
      # easier if we store occupied spaces on assignments model
  end

  def customer_count
    bookings.map(&:size).sum
  end
end
