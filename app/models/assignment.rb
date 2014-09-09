class Assignment < ActiveRecord::Base
  belongs_to :timeslot
  belongs_to :boat

  scope :available_to, ->(timeslot_id) { where("booked_timeslot_id IS NULL or booked_timeslot_id = #{timeslot_id}") }

  def overlapping_assignments
    all_assignments = Assignment.where(boat_id: self.boat_id)
    assignment_time_ranges = all_assignments.inject({}) {|hash, assignment| hash[assignment] = assignment.timeslot.start_time..assignment.timeslot.start_time+assignment.timeslot.duration; hash}

    assignment_time_ranges.select{|assignment, range| range.include?(timeslot.start_time) || range.include?(timeslot.start_time+timeslot.duration)}
    assignment_time_ranges.keys
  end

  private
  # do this check after making a booking and then mark what timeslot is using assignment
  def boat_available
    all_assignments = Assignment.where(boat_id: self.boat_id)
    assignment_time_ranges = all_assignments.map(&:timeslot).map{|ts| ts.start_time..ts.start_time+ts.duration}

    available = assignment_time_ranges.map{|range| !range.include?(timeslot.start_time) && !range.include?(timeslot.start_time+timeslot.duration)}.all?
    errors.add(:boat, "not available") unless available
  end
end
