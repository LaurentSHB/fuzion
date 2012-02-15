#encoding: utf-8
class TeamsController < ApplicationController
  def index
    response.headers['Cache-Control'] = 'public, max-age=300'
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
