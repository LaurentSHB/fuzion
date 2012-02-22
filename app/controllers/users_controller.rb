#encoding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate_user!, :find_user, :only => [:update, :edit]

  #Le cache est renouvellé une fois par jour hormis si un résultat est modifié
  caches_action :index, :expires_in => 1.day
  
  def edit

  end

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
    end
    @user.attributes = params[:user]


    if @user.save
      flash[:notice] = "L'utilisateur a été mise à jour avec succès!"
      redirect_to  edit_user_path(current_user)
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'utilisateur."
      render :edit
    end
  end

  def index
    params[:year] ||= CURRENT_YEAR
    @users = User.activated.order("number ASC")
    @competitions = Competition.find_all_by_year(params[:year])
    #@competitions = Competition.where("ended = ?", false)
    @competitions.each do |competition|
      if competition.competition_type == "Amical" && params[:add_amical].blank?
        competition[:in_total] = false
      else
        competition[:in_total] = true
      end
      
    end
  end
  private

  def find_user
    @user = current_user
  end
end
