class HomeController < ApplicationController
  def index
    @last_match = Match.filter_by_team(Team.find_by_is_fuzion(true).id).ended.last
  end
end
