class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  validates :description, :presence => true
  validates :commentable_id, :presence => true
  validates :commentable_type, :presence => true
  validates :user_id, :presence => true
end
