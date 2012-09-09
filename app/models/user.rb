class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :lastname,
    :firstname, :number, :poste, :phone, :role, :active, :user_qualifications_attributes

  POSTES = ["Gardien", "Defenseur", "Milieu", "Attaquant"]

  has_many :participations
  has_many :user_qualifications, :order => "year"
  has_many :matches, :through => :participations

  accepts_nested_attributes_for :user_qualifications

  scope :activated, where(["active = ?", true])
  scope :qualified_for_year, lambda{|y|
    joins(:user_qualifications).where("user_qualifications.year = ?", y).where("user_qualifications.qualified = ?", true)
  }

  after_create :create_user_participations

  def is_admin?
    self.role == "admin"
  end

  def is_super_admin?
    self.role == "super_admin"
  end

  def is_admin_or_super_admin?
    self.is_admin? || self.is_super_admin?
  end

  def full_name
    "#{self.firstname} #{self.lastname}"
  end

  def played?(match)
    m = self.participations.find_by_match_id_and_convocation(match.id, true)
    !m.blank?
  end

  def stats(competitions)
    hash={}
    competitions.each do |competition|
      stats = {:days => 0, :goals => 0, :passes => 0, :notation => 0, :nb_notation => 0, :in_total => competition[:in_total]}
      competition.matches.ended.each do |match|
        part = self.participations.find_by_match_id_and_convocation(match.id, true)
        
        if !part.blank?
          
          stats[:days] += 1
          stats[:goals] += part.goals.to_i
          stats[:passes] += part.passes.to_i
          stats[:notation] = (stats[:notation] * stats[:nb_notation] + part.notation.to_f) / (stats[:nb_notation] + 1) if part.notation.to_f > 0
          stats[:nb_notation] += 1 if part.notation.to_f > 0
        end
      end
      hash[:"#{competition.competition_type.downcase}"] = stats
    end
    
    stats = {:days => 0, :goals => 0, :passes => 0, :notation => 0, :nb_notation => 0}
    hash.each do |h|
      s = h.last
      if s[:in_total]
        stats[:days] += s[:days]
        stats[:goals] += s[:goals]
        stats[:passes] += s[:passes]
        stats[:notation] = (stats[:notation] * stats[:nb_notation] + s[:notation]) / (stats[:nb_notation] + 1) if s[:notation].to_f > 0
        stats[:nb_notation] += 1 if s[:notation].to_f > 0
      end
    end
    hash[:total] = stats
    hash
  end

  private

  def create_user_participations
    [2011, 2012, 2013, 2014, 2015, 2016].each do |year|
        self.user_qualifications.create(:year => year)
      end
  end
end
