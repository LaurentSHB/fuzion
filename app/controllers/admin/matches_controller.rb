#encoding: utf-8
class Admin::MatchesController < Admin::AreaController
  
  before_filter :find_match, :only => [ :edit, :update, :destroy, :scoresheet, :update_scoresheet ]

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

    selected_month_max = Time.new(@month == 12 ? @year + 1 :@year,@month == 12 ? 1 : @month + 1 )
    selected_month_min = Time.new(@year, @month)
    request << "date >= ? AND date < ?"
    ary_for_request << selected_month_min
    ary_for_request << selected_month_max
    ary_for_request[0] = request.join(" AND ")
    @matches = Match.where(ary_for_request).all(:order => "date ASC")
    @match = Match.new
    @competitions = Competition.all
    @teams_for_select = Competition.first.teams.collect{|t| [t.name, t.id]}
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
    (9 - @match.players.count).times{ @match.participations.build }
    @match.participations.build
    @users_for_select = [[""]] + (User.activated - @match.players).collect{|u| [u.full_name, u.id]}
    @presents = @match.presents
    @absents = @match.absents
    @presence_unknown = User.activated - @presents - @absents
  end


  def update_scoresheet
    if !params[:unsubscribe].blank?
      params[:unsubscribe].each do |participation_id|
        p = Participation.find participation_id.first
        p.convocation = false
        p.save
      end
    end


    params[:match][:participations_attributes].each do |participation|
      part = participation.last
      if part[:id].blank? && part[:user_id].blank?
        params[:match][:participations_attributes].delete(participation.first)
      end
      if part[:id].blank? && !part[:user_id].blank?
        p = Participation.find_by_user_id_and_match_id part[:user_id], @match.id
        if !p.blank?
          params[:match][:participations_attributes][participation.first][:id] = p.id
        end
      end
    end
    #raise params[:match][:participations_attributes].inspect
    if @match.update_attributes(params[:match])
      flash[:notice] = "Feuille de match enregistrée"
    else
      flash[:error] = "Problème lors de l'enregistrement"
    end

    redirect_to scoresheet_admin_match_path(@match)
  end


  def destroy
    @match.destroy
    redirect_to admin_matches_path

  end

  def select_teams
    competition = Competition.find params[:competition_id]
    @teams_for_select = competition.teams.all.collect{|t| [t.name, t.id]}
    render :partial => "select_team", :locals => {:id_select => params[:select_name]}
  end
  private
  def find_match
    @match = Match.find params[:id]
  end

  def authorized_for_super_admin
    authorize! :view_super_admin_side, nil
  end
end
