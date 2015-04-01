class CalendarsController < ApplicationController
  before_filter :require_current_user!, :only => [:show]
  # calendar based on user_id
  def show
    @user = User.find(params[:user_id])
  end
end
