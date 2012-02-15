class HomeController < ApplicationController
  def index
    response.headers['Cache-Control'] = 'public, max-age=300'
    @last_match = Match.filter_by_team(Team.find_by_is_fuzion(true).id).ended.last
  end
  
  def login_content
    
  end
end
