#encoding: utf-8
class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    if @comment.save
      flash[:notice] = "Commentaire ajouté"
    else
      flash[:error] = "Erreur"
    end

    redirect_to :back
  end

  def destroy

    @comment = Comment.find(params[:id])
    authorize! :delete_comment, @comment
    if @comment.destroy
      flash[:notice] = "Commentaire supprimé"
    else
      flash[:error] = "Erreur"
    end

    redirect_to :back
  end

  def edit
    @comment = Comment.find(params[:id])
    authorize! :edit_comment, @comment
  end

  def update
    @comment = Comment.find(params[:id])
    authorize! :edit_comment, @comment
    if @comment.update_attributes(params[:comment])
      if @comment.commentable.is_a?(Match)
        redirect_to match_path(@comment.commentable_id, :anchor=> "comments")
      else
        redirect_to :back
      end
    else
      render :edit
    end
  end

  private

 
end
