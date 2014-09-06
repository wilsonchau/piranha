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
    return true if party_size >= availability

    # if not then try to redo fit with new booking
    boat_capacities = boats.map(&:size).sort
    booking_groups = (bookings.map(&:size) << party_size).sort

    # try to fit group onto boat with smallest capacity left that will fit group
    booking_groups.each do |group_size|
      capacity_index = boat_capacities.index{|capacity| capacity >= group_size}
      return false unless capacity_index

      boat_capacities[capacity_index] -= group_size
      boat_capacities.sort!
    end

    true
  end

  def update_availability
    boat_capacities = boats.map(&:size).sort
    booking_groups = bookings.map(&:size).sort

    booking_groups.each do |group_size|
      capacity_index = boat_capacities.index{|capacity| capacity >= group_size}
      boat_capacities[capacity_index] -= group_size
      boat_capacities.sort!
    end

    update_attribute(:availability, boat_capacities.max)
  end

  def customer_count
    bookings.map(&:size).sum
  end
end
