#encoding: utf-8
class Match < ActiveRecord::Base
  
  COMPOSITIONS = {
    "3-2-1" => { :player_1 => "Gardien", :player_2 => "Libéro", :player_3 => "Def Gauche",
      :player_4 => "Def Droit", :player_5 => "Milieu Gauche", :player_6 => "Milieu Droit",
      :player_7 => "Attaquant" },
    "2-3-1" => { :player_1 => "Gardien", :player_2 => "Def Gauche", :player_3 => "Def Droit",
      :player_4 => "Milieu Centre", :player_5 => "Milieu Gauche", :player_6 => "Milieu Droit",
      :player_7 => "Attaquant" }
  }

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

  has_many :participations
  has_many :players, :through => :participations, :source => :user, :conditions => ["convocation = ?", true]
  has_many :presents, :through => :participations, :source => :user, :conditions => ["presence = ?", "P"]
  has_many :absents, :through => :participations, :source => :user, :conditions => ["presence = ?", "A"]

  validates :competition_id, :presence => true
  validates :team_dom_id, :presence => true
  validates :team_ext_id, :presence => true
  validates :date, :presence => true


  before_validation :add_minute_and_hour_to_date

  accepts_nested_attributes_for :participations

  scope :filter_by_team, lambda{ |team_id|
    where("team_dom_id = ? OR team_ext_id = ?", team_id, team_id).order("date ASC")
  }
  #A modifier en cas d'édition
  def add_minute_and_hour_to_date
    self.date = Date.today if self.date.blank?

    self.date += self.minute_for_date.to_i.minutes if !self.minute_for_date.blank?
    
    self.date += self.hour_for_date.to_i.hours if !self.hour_for_date.blank?
  end

  def fuzion_play?
    self.team_dom.is_fuzion || self.team_ext.is_fuzion
  end

  def ended?
    !self.score_dom.blank? || !self.score_ext.blank?
  end

  def affiche
    "#{self.team_dom.name} - #{self.team_ext.name}"
  end
end
