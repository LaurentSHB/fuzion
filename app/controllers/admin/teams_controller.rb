#encoding: utf-8
class Admin::TeamsController < Admin::AreaController
  before_filter :authorized_for_super_admin
  
  before_filter :find_team, :only => [ :edit, :update, :destroy ]

  def index
    @teams = Team.all(:order => "id ASC")
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(params[:team])

    if @team.save
      flash[:notice] = "L'équipe a été ajoutée avec succès!"
      redirect_to admin_teams_path
    else
      flash[:error] = "Une erreur s'est produite lors de l'ajout de l'équipe."
      render :new
    end
  end
  def edit

  end
  def update
    @team.attributes = params[:team]


    if @team.save
      flash[:notice] = "L'équipe a été mise à jour avec succès!"
      redirect_to admin_teams_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'équipe."
      render :edit
    end

  end

  def destroy
    @team.destroy
    redirect_to admin_teams_path

  end

  private
  def find_team
    @team = Team.find params[:id]
  end

  def authorized_for_super_admin
    authorize! :view_super_admin_side, nil
  end
end
