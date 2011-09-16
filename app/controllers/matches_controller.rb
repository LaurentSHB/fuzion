class MatchesController < ApplicationController
  def index
    @team = Team.find_by_is_fuzion true
    @matches = Match.filter_by_team(@team.id)
  end
end
