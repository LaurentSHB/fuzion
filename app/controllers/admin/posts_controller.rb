#encoding: utf-8
class Admin::PostsController < Admin::AreaController
  before_filter :find_keywords, :only => [ :edit, :update ]
  before_filter :find_post, :only => [ :edit, :update, :destroy, :update_position,:toggle_highlighted ]
  before_filter :get_all_section, :only => [ :edit, :new, :create, :update ]
  def index
    @posts = Post.all

    
  end
  def new
    @post = Post.new
  end
  def toggle_highlighted
    
    Post.update_all("is_highlighted=false", "id != #{@post.id}")
    
    @post.toggle(:is_highlighted)
    if @post.save
      flash[:notice] = "L'actualité a été modifié!"
    else
      flash[:error] ="Une erreur s'est produite lors de la modification de l'actualité."
    end
    redirect_to admin_posts_path

  end
  def create
    
    
    
   
    @post = Post.new

    #Gestion Image
    if params[:post][:picture_marked_for_deletion].blank?
      @post.picture = Asset::Picture.new(:asset => params[:post][:picture]) unless params[:post][:picture].blank?
    end


    #Gestion Fichier
    if params[:post][:document_marked_for_deletion].blank?
      @post.document = Asset::Document.new(:asset => params[:post][:document]) unless params[:post][:document].blank?
    end

    params[:post].delete :document
    params[:post].delete :picture
    
    
     if !params[:post][:is_highlighted].blank? && params[:post][:is_highlighted]
      Post.update_all(:is_highlighted => false)
    end
    @post.attributes = params[:post]
    
    #Gestion tags
    @post.tags.clear
    params[:tag_post][:tags].split(" ").each do |tag|
      @post.tags << Tag.find_or_initialize_by_title(tag) if !tag.blank?
    end





    if @post.save

      #Diaporama
      slideshow_params = params[:slideshow] || {}

      unless slideshow_params[:add].blank?
        slideshow_params[:add].each do |key,value|
          img = Asset::Picture.new(:asset => value[:id])
          if img.save
            slide = Slideshow.new
            slide.picture = img
            slide.slidable = @post
            slide.title = value[:title]
            slide.save
          end
        end
      end
      #Fin Diaporama



      flash[:notice] = "L'actualité a été ajoutée avec succès!"
      redirect_to admin_posts_path
    else
      flash[:error] = "Une erreur s'est produite lors de l'ajout de l'actualité."
      render :new
    end
  end
  def edit

  end

  def update

   
    if !params[:post][:is_highlighted].blank? && params[:post][:is_highlighted]
      Post.update_all(:is_highlighted => false)
    end
    
    #Gestion Image
    if params[:post][:picture_marked_for_deletion].blank?
      unless params[:post][:picture].blank?
        picture_to_destroy = @post.picture
        @post.picture = Asset::Picture.new(:asset => params[:post][:picture])
      end
    else
      @post.picture.destroy
    end

    #Gestion Fichier
    if params[:post][:document_marked_for_deletion].blank?
      unless params[:post][:document].blank?
        file_to_destroy = @post.document
        @post.document = Asset::Document.new(:asset => params[:post][:document])
      end
    else
      @post.document.destroy
    end
    params[:post].delete :document
    params[:post].delete :picture
    
    
    @post.attributes = params[:post]
    
    #Gestion tags
    @post.tags.clear
    params[:tag_post][:tags].split(" ").each do |tag|
      @post.tags << Tag.find_or_initialize_by_title(tag) if !tag.blank?
    end




    #Diaporama
    slideshow_params = params[:slideshow] || {}


    unless slideshow_params[:update].blank?
      slideshow_params[:update].each do |key, value|
        picture_id = slideshow_params[:fields][key][:picture][:id].to_i
        s = Slideshow.find_by_picture_id_and_slidable_id_and_slidable_type(picture_id,@post.id,"Post")
        s.title = value[:title]
        s.insert_at(value[:position])
        s.save
          
      end
    end

    
    unless slideshow_params[:delete].blank?
      slideshow_params[:delete].each do |key, deletion|
        picture_id = slideshow_params[:fields][key][:picture][:id].to_i

        Slideshow.find_by_picture_id_and_slidable_id_and_slidable_type(picture_id,@post.id,"Post").destroy
        #        Diaporama.find_by_program_id_and_image_id(@program.id, key).destroy
      end
    end

    unless slideshow_params[:add].blank?
      slideshow_params[:add].each do |key,value|
        img = Asset::Picture.new(:asset => value[:id])
        if img.save
          slide = Slideshow.new
          slide.picture = img
          slide.slidable = @post
          slide.title = value[:title]
          slide.save
        end
      end
    end

    #Fin Diaporama


    if @post.save
      picture_to_destroy.destroy if !picture_to_destroy.blank?
      file_to_destroy.destroy if !file_to_destroy.blank?
      flash[:notice] = "L'actualité a été mise à jour avec succès!"
      redirect_to admin_posts_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'actualité."
      render :edit
    end

  end

  def destroy
    @post.destroy
    redirect_to admin_posts_path

  end

  private
  def get_all_section
    @section = Section.all(:order => "title ASC")
  end
  def find_post
    @post = Post.find params[:id]
  end
  def find_keywords
    @keywords = Post.find(params[:id]).tags.collect{|k| [ k.title ] }.join(" ")

  end

end
