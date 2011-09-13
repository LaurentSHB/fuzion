#encoding: utf-8
class Admin::MatchesController < Admin::AreaController
  
  before_filter :find_match, :only => [ :edit, :update, :destroy, :scoresheet ]

  def index
    ary_for_request = [""]
    request = []
    @year = params[:filter_by_year].blank? ? Date.today.year : params[:filter_by_year].to_i
    @month = params[:filter_by_month].blank? ? Date.today.month : params[:filter_by_month].to_i
    if !params[:filter_by_team].blank?
      request << "(team_dom_id = ? OR team_ext_id = ?)"
      ary_for_request << params[:filter_by_team]
      ary_for_request << params[:filter_by_team]
    end

    selected_month_max = Time.new(@year, @month + 1 )
    selected_month_min = Time.new(@year, @month)
    request << "date >= ? AND date < ?"
    ary_for_request << selected_month_min
    ary_for_request << selected_month_max
    ary_for_request[0] = request.join(" AND ")
    @matches = Match.where(ary_for_request).all(:order => "date ASC")
    @match = Match.new
    @teams_for_select = Team.all.collect{|t| [t.name, t.id]}
  end

  def create
    @match = Match.new(params[:match])

    if @match.save
      flash[:notice] = "Le match a été ajouté avec succès!"
      redirect_to admin_matches_path
    else
      flash[:error] = "Une erreur s'est produite lors de l'ajout du match."
      @matches = Match.all(:order => "date DESC")
      render :index
    end
  end

  def edit
    @teams_for_select = Team.all.collect{|t| [t.name, t.id]}
    @match.hour_for_date = @match.date.hour
    @match.minute_for_date = @match.date.min
  end
  
  def update
    @match.attributes = params[:match]

    saved = @match.save
    respond_to do |format|
      format.html {
        if saved
          flash[:notice] = "Le match a été mise à jour avec succès!"
          redirect_to admin_matches_path
        else
          flash[:error] = "Une erreur s'est produite lors de la mise à jour du match."
          redirect_to admin_matches_path
        end

      }
      format.js {
        if saved
          render :inline =>  "$('#valid_match_#{@match.id}').hide();$('#ok_match_#{@match.id}').show()"
        else
          render :inline => "alert('Erreur lors de la sauvegarde du résultat #{@match.errors}'"
        end
      }
    end
  end

  def scoresheet
    
  end


  def destroy
    @match.destroy
    redirect_to admin_matches_path

  end

  private
  def find_match
    @match = Match.find params[:id]
  end

  def authorized_for_super_admin
    authorize! :view_super_admin_side, nil
  end
end
