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
      p = user.participations.find_by_match_id(match.id)
      !p.blank? && p.convocation && !p.notation_done
    end
        
#
#    can :view_details, Program do |program|
#      !user.blank?
#    end
  end

end
