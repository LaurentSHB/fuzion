class Team < ActiveRecord::Base
  has_many :team_competitions
  has_many :competitions, :through => :team_competitions

  accepts_nested_attributes_for :team_competitions

  def get_stats(competition)
    hash = {:days => 0, :victoires => 0, :nuls => 0, :defaite => 0, :goals_in => 0, :goals_out => 0, :points => 0 }
    matches = competition.matches.ended.filter_by_team(self.id)
    matches.each do |match|
      
    end
  end
end
