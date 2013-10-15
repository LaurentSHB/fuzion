class Team < ActiveRecord::Base
  has_many :team_competitions
  has_many :competitions, :through => :team_competitions

  accepts_nested_attributes_for :team_competitions

  def get_stats(competition)
    hash = {:days => 0, :victoires => 0, :nuls => 0, :defaite => 0, :goals_in => 0, :goals_out => 0, :points => 0 }
    matches = competition.matches.ended.filter_by_team(self.id)
    matches.each do |match|
      hash[:days] += 1
      result = match.result(self)
      case result
      when "nul"
        hash[:nuls] += 1
        points = 2
      when "victoire"
        hash[:victoires] += 1
        points = competition.year >= 2013 ? 4 : 3
      when "defaite"
        hash[:defaite] += 1
        points = 1
      end
      if match.team_dom_id == self.id
        hash[:goals_in] += match.score_dom
        hash[:goals_out] += match.score_ext
      else
        hash[:goals_in] += match.score_ext
        hash[:goals_out] += match.score_dom
      end
     
        hash[:points] += points  if !(match.withdrawal && result == "defaite")
    
    end

    hash[:points] -= self.team_competitions.find_by_competition_id(competition.id).penalty.to_i
    hash
    #raise hash.inspect if self.is_fuzion
  end
end
