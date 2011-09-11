class Competition < ActiveRecord::Base
  
  TYPES = ["Amical", "Coupe", "Championnat"]

  has_many :team_competitions
  has_many :teams, :through => :team_competitions

end
