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

  has_many :comments, :as => :commentable
  
  validates :competition_id, :presence => true
  validates :team_dom_id, :presence => true
  validates :team_ext_id, :presence => true
  validates :date, :presence => true


  before_validation :add_minute_and_hour_to_date

  before_save :set_city

  accepts_nested_attributes_for :participations

  scope :filter_by_team, lambda{ |team_id|
    where("team_dom_id = ? OR team_ext_id = ?", team_id, team_id).order("date ASC")
  }
  scope :filter_by_year, lambda{ |year|
    joins(:competition).where("competitions.year = ?", year).order("date ASC")
  }

  scope :ended, where("score_dom IS NOT NULL AND score_ext IS NOT NULL")
  #A modifier en cas d'édition
  def add_minute_and_hour_to_date
    self.date = Date.today if self.date.blank?

    self.date += self.minute_for_date.to_i.minutes if !self.minute_for_date.blank?
    
    self.date += self.hour_for_date.to_i.hours if !self.hour_for_date.blank?
  end

  def set_city
    self.city = self.team_dom.city
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

  def affiche_with_score
    "#{self.team_dom.name} ( #{self.score_dom} - #{self.score_ext} ) #{self.team_ext.name}"
  end

  def notation_out_date
    Time.new(self.date.year, self.date.month, self.date.day + 2, 12 )
  end

  def fuzion_result?
    if fuzion_play?
      result(self.team_dom.is_fuzion ? self.team_dom : self.team_ext)
    else
      ""
    end
  end

  def result(team)
    if self.score_dom == self.score_ext
      "nul"
    else
        if self.team_dom_id == team.id && self.score_dom > self.score_ext || self.team_ext_id == team.id && self.score_dom < self.score_ext
          "victoire"
        else
          "defaite"
        end
      end
  end
end
