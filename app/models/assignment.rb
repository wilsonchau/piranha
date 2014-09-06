class Assignment < ActiveRecord::Base
  belongs_to :timeslot
  belongs_to :boat

  validate :boat_available

  private
  def boat_available
    all_assignments = Assignment.where(boat_id: self.boat_id)
    assignment_time_ranges = all_assignments.map(&:timeslot).map{|ts| ts.start_time..ts.start_time+ts.duration}

    assignment_time_ranges.map{|range| !range.include?(timeslot.start_time) && !range.include?(timeslot.start_time+timeslot.duration)}.all?
  end
end
