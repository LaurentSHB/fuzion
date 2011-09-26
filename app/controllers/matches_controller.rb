#encoding: utf-8
class MatchesController < ApplicationController
  before_filter :authenticate_user!, :only => [:set_participation, :update_participation, :update_participation_from_mail, :set_notation, :update_notation]
  before_filter :find_match, :only => [:show, :set_participation, :update_participation, :update_participation_from_mail, :set_notation, :update_notation]

  def index
    @team = Team.find_by_is_fuzion true
    @matches = Match.filter_by_team(@team.id)
  end

  def set_participation
    @participation = Participation.find_by_user_id_and_match_id(current_user.id, @match.id)
    @participation = Participation.new if @participation.blank?
  end

  def update_participation
    if params[:participation][:id].blank?
      participation = current_user.participations.new
      participation.match_id = @match.id
      #params[:participation].delete(:id)
    else
      participation = current_user.participations.find params[:participation][:id]
    end
    participation.attributes = params[:participation]
    if participation.save
      flash[:notice] = "Votre disponibilité a été mise à jour"
    else
      flash[:error] = "Impossible de mettre à jour votre disponibilité"
    end
    redirect_to matches_path
  end

  def update_participation_from_mail
    if params[:presence] == "P" || params[:presence] == "A"
      @participation = Participation.find_by_match_id_and_user_id(@match.id, current_user.id)
      @participation = current_user.participations.new(:match_id => @match.id) if @participation.blank?
      @participation.presence = params[:presence]
      if @participation.save
        @valid = true
      else
        @valid = false
      end
    else
      @valid = false
    end
  end

  def show
    if !@match.ended? || !@match.fuzion_play?
      redirect_to matches_path
    end
  end

  def set_notation
    authorize! :set_notation,@match
    @participations = @match.participations.convoqued.where('user_id != ?', current_user.id)
  end

  def update_notation
    authorize! :set_notation,@match
    params[:note].each do |note|
      participation = Participation.find(note.first)
      participation.set_notation(note.last)
    end
    user_part = Participation.find_by_match_id_and_user_id(@match.id, current_user.id)
    user_part.update_attribute(:notation_done, true)
    flash[:notice] = "Les notes ont été enregistrées avec succès"
    redirect_to match_path @match
  end
  private

  def find_match
    @match = Match.find params[:id]
  end
end
