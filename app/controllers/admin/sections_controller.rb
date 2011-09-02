#encoding: utf-8
class Admin::SectionsController < Admin::AreaController
 before_filter :find_section, :only => [ :edit, :update, :destroy, :update_position ]
  def index
     @sections = Section.all(:order => "position ASC")
  end
  def new
    @section = Section.new
  end

  def create
    @section = Section.new(params[:section])

    if @section.save
      flash[:notice] = "La rubrique a été ajoutée avec succès!"
      redirect_to admin_sections_path
    else
      flash[:error] = "Une erreur s'est produite lors de l'ajout de la rubrique."
      render :new
    end
  end
  def edit

  end
  def update

    @section.attributes = params[:section]


     if @section.save
      flash[:notice] = "La rubrique a été mise à jour avec succès!"
      redirect_to admin_sections_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de la rubrique."
      render :edit
    end

  end

  def destroy
    @section.destroy
    redirect_to admin_sections_path

  end
  def update_position
    @section.insert_at(params[:position])
    redirect_to admin_sections_path
  end
 private
  def find_section
    @section = Section.find params[:id]
  end

end
