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
    return true if availability >= party_size

    # if not then try to redo fit with new booking
    booking_sizes = (bookings.map(&:size) << party_size)
    return false unless availability(booking_sizes) > 0

    true
  end

  def availability(booking_sizes = bookings.map(&:size))
    boat_capacities = boats.map(&:capacity).sort
    return 0 if boat_capacities.empty?

    # fit biggest bookings first to boats with smallest possible remaining capacity
    booking_sizes.sort.reverse.each do |group_size|
      capacity_index = boat_capacities.index{|capacity| capacity >= group_size}
      return 0 unless capacity_index

      boat_capacities[capacity_index] -= group_size
      boat_capacities.sort!
    end

    boat_capacities.max
  end

  def customer_count
    bookings.map(&:size).sum
  end
end
