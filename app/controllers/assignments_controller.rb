class AssignmentsController < ApplicationController
  def create
    assignment_params = params.permit(:timeslot_id, :boat_id)

    Assignment.create(assignment_params)
  end
end
