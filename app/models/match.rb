class Match < ActiveRecord::Base

  attr_accessor :minute_for_date, :hour_for_date
  
  belongs_to :competition
  belongs_to :team_dom, :class_name => "Team"
  belongs_to :team_ext, :class_name => "Team"
  belongs_to :player_1, :class_name => "User"
  belongs_to :player_1_bis, :class_name => "User"
  belongs_to :player_2, :class_name => "User"
  belongs_to :player_2_bis, :class_name => "User"
  belongs_to :player_3, :class_name => "User"
  belongs_to :player_3_bis, :class_name => "User"
  belongs_to :player_4, :class_name => "User"
  belongs_to :player_4_bis, :class_name => "User"
  belongs_to :player_5, :class_name => "User"
  belongs_to :player_5_bis, :class_name => "User"
  belongs_to :player_6, :class_name => "User"
  belongs_to :player_6_bis, :class_name => "User"
  belongs_to :player_7, :class_name => "User"
  belongs_to :player_7_bis, :class_name => "User"

  validates :competition_id, :presence => true
  validates :team_dom_id, :presence => true
  validates :team_ext_id, :presence => true
  validates :date, :presence => true


  before_validation :add_minute_and_hour_to_date

#A modifier en cas d'édition
  def add_minute_and_hour_to_date
    self.date = Date.today if self.date.blank?

    self.date += self.minute_for_date.to_i.minutes if !self.minute_for_date.blank?
    
    self.date += self.hour_for_date.to_i.hours if !self.hour_for_date.blank?
  end

end
