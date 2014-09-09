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

  def book(size)
    available_assignments = assignments.available_to(self.id).inject({}) {|hash, assignment| hash[assignment.id] = assignment.boat.capacity; hash}.sort_by{|k,v| v}
    return false if available_assignments.empty?

    # unbook all assignments so that we can try to refit
    Assignment.where(booked_timeslot_id: self.id).map{|a| a.update_attributes(booked_timeslot_id: nil)}

    assignments_to_book = []
    # fit biggest bookings first to boats with smallest possible remaining capacity
    booking_sizes = bookings.map(&:size) << size
    booking_sizes.sort.reverse.each do |group_size|
      assignment_index = available_assignments.find_index{|id, capacity| capacity >= group_size}
      return false unless assignment_index

      available_assignments[assignment_index][1] -= group_size

      assignment = assignments.find(available_assignments[assignment_index][0])
      assignments_to_book << assignment << assignment.overlapping_assignments

      available_assignments = available_assignments.sort_by{|k,v| v}
    end
    assignments_to_book.flatten.uniq.map{|a| a.book(self.id) }
  end

  def availability
    boat_capacities = assignments.available_to(self.id).map{|assignment| assignment.boat.capacity}.sort
    return 0 if boat_capacities.empty?

    # fit biggest bookings first to boats with smallest possible remaining capacity
    bookings.map(&:size).sort.reverse.each do |group_size|
      assignment_index = boat_capacities.index{|capacity| capacity >= group_size}
      return 0 unless assignment_index

      boat_capacities[assignment_index] -= group_size
      boat_capacities.sort!
    end

    boat_capacities.max
  end

  def customer_count
    bookings.map(&:size).sum
  end
end
