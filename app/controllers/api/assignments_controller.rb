class Api::AssignmentsController < ApplicationController
  def create
    assignment_params = params.require(:assignment).permit(:timeslot_id, :boat_id)
    Assignment.create(assignment_params)
    
    head :ok
  end
end
