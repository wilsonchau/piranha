class BoatsController < ApplicationController
  def index
    render json: Boat.all
  end

  def create
    boat_params = params.permit(:name, :size)

    render json: Boat.create(boat_params)
  end
end
