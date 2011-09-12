#encoding: utf-8
class Admin::MatchesController < Admin::AreaController
  
  before_filter :find_competition, :only => [ :edit, :update, :destroy ]

  def index
    #request = params[:filter_by_team]
    @matches = Match.all(:order => "date ASC")
    @match = Match.new
  end

  def create
    @match = Match.new(params[:match])

    if @match.save
      flash[:notice] = "L'équipe a été ajoutée avec succès!"
      redirect_to admin_matches_path
    else
      flash[:error] = "Une erreur s'est produite lors de l'ajout de l'équipe."
      @matches = Match.all(:order => "date DESC")
      render :index
    end
  end
  def edit

  end
  def update
    @competition.attributes = params[:competition]


    if @competition.save
      flash[:notice] = "L'équipe a été mise à jour avec succès!"
      redirect_to admin_competitions_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'équipe."
      render :edit
    end

  end

  def destroy
    @competition.destroy
    redirect_to admin_competitions_path

  end

  private
  def find_competition
    @competition = Competition.find params[:id]
  end

  def authorized_for_super_admin
    authorize! :view_super_admin_side, nil
  end
end
