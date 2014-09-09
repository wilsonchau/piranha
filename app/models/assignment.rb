class Assignment < ActiveRecord::Base
  belongs_to :timeslot
  belongs_to :boat

  scope :available_to, ->(timeslot_id) { where("booked_timeslot_id IS NULL or booked_timeslot_id = #{timeslot_id}") }

  def book(timeslot_id)
    update_attributes(booked_timeslot_id: timeslot_id)
  end

  def overlapping_assignments
    all_assignments = Assignment.where(boat_id: self.boat_id)
    assignment_time_ranges = all_assignments.inject({}) {|hash, assignment| hash[assignment] = assignment.timeslot.start_time..assignment.timeslot.start_time+assignment.timeslot.duration; hash}

    assignment_time_ranges.select{|assignment, range| range.include?(timeslot.start_time) || range.include?(timeslot.start_time+timeslot.duration)}
    assignment_time_ranges.keys
  end
end
