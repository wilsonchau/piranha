class Boat < ActiveRecord::Base
  has_many :timeslots, through: :assignments

  def as_json
  end
end
