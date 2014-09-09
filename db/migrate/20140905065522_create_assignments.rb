class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :timeslot_id
      t.integer :boat_id
      t.integer :booked_timeslot_id

      t.timestamps
    end
    add_index :assignments, ["timeslot_id", "boat_id"], :unique => true
  end
end
