class StaticsController < ApplicationController
  #Le cache est renouvellé une fois par jour hormis si un résultat est modifié
  caches_action :index, :expires_in => 1.day

  def palmares
  end

end
