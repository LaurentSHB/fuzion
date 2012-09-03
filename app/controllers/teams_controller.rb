#encoding: utf-8
class TeamsController < ApplicationController
  
  #Le cache est renouvellé une fois par jour hormis si un résultat est modifié
  caches_action :index, :expires_in => 1.week
  def index
    get_classement_data
    
  end

  def get_another_year
    if params[:year].blank? || params[:year].to_i == CURRENT_YEAR
      redirect_to teams_path, :status => 301
    else
      redirect_to show_past_year_teams_path(params[:year]), :status => 301
    end
  end
  
  def show_past_year
    if !params[:year].blank? && params[:year].to_i >= 2011
      get_classement_data
    end
    render :index
  end

  def show
    @team = Team.find params[:id]
    @matches = Match.filter_by_team(@team.id)
  end

  private
  def get_classement_data
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
end
