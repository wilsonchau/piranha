class Api::BoatsController < ApplicationController
  def index
    render json: Boat.all
  end

  def create
    boat_params = params.require(:boat).permit(:name, :capacity)

    render json: Boat.create(boat_params)
  end
end
