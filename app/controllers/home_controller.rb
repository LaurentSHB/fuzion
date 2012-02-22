class HomeController < ApplicationController
  #Le cache est renouvellé une fois par jour hormis si un résultat est modifié
  caches_action :index, :expires_in => 1.day

  def index
    @last_match = Match.filter_by_team(Team.find_by_is_fuzion(true).id).ended.last
  end
  
  def login_content
    
  end
end
