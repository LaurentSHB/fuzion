#encoding: utf-8
class TeamsController < ApplicationController
  def index
    @competition = Competition.find_by_competition_type_and_ended("Championnat", false)
    @teams = @competition.teams
  end

end
