#encoding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate_user!, :find_user, :only => [:update, :edit]

  #Le cache est renouvellé une fois par jour hormis si un résultat est modifié
  caches_action :index, :expires_in => 1.week
  
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
      get_users_data
  end

  def get_another_year
    if params[:year].blank? || params[:year].to_i == CURRENT_YEAR
      redirect_to users_path, :status => 301
    else
      redirect_to show_past_year_users_path(params[:year]), :status => 301
    end
  end
  def show_past_year
    if !params[:year].blank? && params[:year].to_i >= 2011
      get_users_data
    end
    render :index
  end
  private

  def find_user
    @user = current_user
  end

  def get_users_data
    params[:year] ||= CURRENT_YEAR
    @users = User.qualified_for_year(params[:year]).order("number ASC")
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
end
