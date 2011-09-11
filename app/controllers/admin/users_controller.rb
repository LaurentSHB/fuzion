#encoding: utf-8
class Admin::UsersController < Admin::AreaController
  before_filter :authorized_for_super_admin
  
  before_filter :find_user, :only => [ :edit, :update, :destroy ]

  def index
    @users = User.all(:order => "id ASC")
  end
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:notice] = "L'utilisateur a été ajoutée avec succès!"
      redirect_to admin_users_path
    else
      flash[:error] = "Une erreur s'est produite lors de l'ajout de l'utilisateur."
      render :new
    end
  end
  def edit

  end
  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
    end
    @user.attributes = params[:user]


    if @user.save
      flash[:notice] = "L'utilisateur a été mise à jour avec succès!"
      redirect_to admin_users_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'utilisateur."
      render :edit
    end

  end

  def destroy
    @user.destroy
    redirect_to admin_users_path

  end
  def update_position
    @user.insert_at(params[:position])
    redirect_to admin_users_path
  end
  private
  def find_user
    @user = User.find params[:id]
  end

  def authorized_for_super_admin
    authorize! :view_super_admin_side, nil
  end
end
