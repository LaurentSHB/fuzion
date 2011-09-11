class Team < ActiveRecord::Base
  has_many :team_competitions
  has_many :competitions, :through => :team_competitions

  accepts_nested_attributes_for :team_competitions
end
