class Timeslot < ActiveRecord::Base
  has_many :boats, through: :assignments
  has_many :bookings

  def book(party_size)
    # check if we have availability
    # look at bookings and do best fit
    # update availability if we used biggest boat
    # update customer count if we decide to hold bookings
    # only when we book do we make a boat unavailable
  end

  def as_json
  end

  def availability
    # based on largest boat capacity
  end

  def customer_count
    # bookings will change this number
  end
end
