class Timeslot < ActiveRecord::Base
  has_many :assignments
  has_many :boats, through: :assignments
  has_many :bookings

  def self.all_during_date(date)
    Timeslot.all.select{|timeslot| Time.at(timeslot.start_time).to_date === date}
  end

  def as_json
    super.merge(availability: availability, customer_count: customer_count, boats: boats.map(&:id))
  end

  def can_accomodate?(group_size)
    booking_sizes = bookings.map(&:size) << group_size
    availability(booking_sizes)
  end

  def availability(booking_sizes = bookings.map(&:size))
    boat_capacities = assignments.available_to(self.id).map{|assignment| assignment.boat.capacity}
    return 0 if boat_capacities.empty?

    # fit biggest bookings first to boats with smallest possible remaining capacity
    booking_sizes.sort.reverse.each do |group_size|
      capacity_index = boat_capacities.index{|capacity| capacity >= group_size}
      return false unless capacity_index

      boat_capacities[capacity_index] -= group_size
      boat_capacities.sort!
    end

    boat_capacities.max
  end

  def book(size)
    available_assignments = assignments.available_to(self.id).inject({}) {|hash, assignment| hash[assignment.id] = assignment.boat.capacity; hash}.sort_by{|k,v| v}
    return 0 if available_assignments.empty?

    # unbook all assignments so that we can try to refit
    Assignment.where(booked_timeslot_id: self.id).map{|a| a.update_attributes(booked_timeslot_id: nil)}

    # fit biggest bookings first to boats with smallest possible remaining capacity
    booking_sizes = bookings.map(&:size) << size
    booking_sizes.sort.reverse.each do |group_size|
      capacity_index = available_assignments.find_index{|id, capacity| capacity >= group_size}
      return false unless capacity_index

      available_assignments[capacity_index][1] -= group_size

      # book assignments again
      assignment = assignments.find(available_assignments[capacity_index][0])
      (assignment.overlapping_assignments << assignment).map{|a| a.update_attributes(booked_timeslot_id: self.id)}

      available_assignments.sort_by{|k,v| v}
    end
  end

  def customer_count
    bookings.map(&:size).sum
  end
end
