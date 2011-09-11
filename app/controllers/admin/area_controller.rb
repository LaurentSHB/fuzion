class Admin::AreaController < ApplicationController
  before_filter :authenticate_user!, :authorized_for_admin
  layout 'administration'

  private
  def authorized_for_admin
    authorize! :view_admin_side, nil
  end
end
