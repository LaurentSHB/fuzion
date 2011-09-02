#encoding: utf-8
class Admin::SeosController < Admin::AreaController
  def index
    @seos = Seo.order("id ASC")
  end
  def update
    @seo = Seo.find params[:id]
    @seo.attributes = params[:seo]
    if @seo.save
      flash[:notice] = "Le référencement a été mis à jour avec succès!"
      redirect_to admin_seos_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du référencement."
      render :edit
    end

  end
end