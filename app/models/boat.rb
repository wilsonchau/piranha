class Boat < ActiveRecord::Base
  has_many :assignments
  has_many :timeslots, through: :assignments
end
