#encoding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate_user!, :find_user


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
  private

  def find_user
    @user = current_user
  end
end
