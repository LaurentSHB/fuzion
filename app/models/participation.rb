class Participation < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :match

  validates :user_id, :presence => true
  validates :match_id, :presence => true

  scope :convoqued, where(["convocation = ?", true])

  scope :present, where("presence = 'P'")
  scope :absent, where("presence = 'A'")
end
