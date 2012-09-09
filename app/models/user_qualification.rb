class UserQualification < ActiveRecord::Base
  attr_accessible :qualified, :year
  belongs_to :user
end