class AddBookedTimeslotIdToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :booked_timeslot_id, :integer
  end
end
