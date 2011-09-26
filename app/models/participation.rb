class Participation < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :match

  validates :user_id, :presence => true
  validates :match_id, :presence => true

  scope :convoqued, where(["convocation = ?", true])

  scope :present, where("presence = 'P'")
  scope :absent, where("presence = 'A'")

  scope :scorer, where("goals > 0").order("goals DESC")
  scope :passer, where("passes > 0").order("passes DESC")
  
  def presence_unknown?
    self.presence != 'P' && self.presence != 'A'
  end

  def present?
    self.presence == 'P'
  end

  def absent?
    self.presence == 'A'
  end

  def set_notation(note)
    self.notation = (self.notation.to_f * self.nb_notation.to_i + note.to_f) / (self.nb_notation.to_i + 1)
    self.nb_notation = self.nb_notation.to_i + 1
    self.save
  end
end
