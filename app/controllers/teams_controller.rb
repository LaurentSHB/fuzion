#encoding: utf-8
class TeamsController < ApplicationController
  
  #Le cache est renouvellé une fois par jour hormis si un résultat est modifié
  caches_action :index, :expires_in => 1.day
  def index
    params[:year] ||= CURRENT_YEAR
    @competition = Competition.find_by_competition_type_and_year("Championnat", params[:year])
    @teams = @competition.teams rescue []
    @teams.each do |team|
      team[:stats] = team.get_stats(@competition)
    end
    @teams.sort_by!{|x|      
      [-x[:stats][:points], -(x[:stats][:goals_in] - x[:stats][:goals_out])];
    }

  end

  def show
    @team = Team.find params[:id]
    @matches = Match.filter_by_team(@team.id)
  end
end
