class Ability
  include CanCan::Ability

  def initialize(user)

    can :view_admin_side do
      user.is_admin_or_super_admin? && user.active
    end
    can :view_super_admin_side do
      user.is_super_admin? && user.active
    end

    can :set_notation, Match do |match|
      if user.blank?
        false
      else
      p = user.participations.find_by_match_id(match.id)
      !p.blank? && p.convocation && !p.notation_done && match.notation_out_date > Time.now
      end
    end
        
#
#    can :view_details, Program do |program|
#      !user.blank?
#    end
  end

end
