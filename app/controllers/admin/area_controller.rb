class Admin::AreaController < ApplicationController
  before_filter :authenticate_user!, :need_admin
  layout 'administration'

  private
  def need_admin
    current_user.is_admin_or_super_admin?
  end
end
