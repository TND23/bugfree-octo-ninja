class UsersController < ApplicationController
  include UsersHelper
  # to make all departments visible (just a bit tidier than Department.all.each....)
  include DepartmentsHelper
  before_filter :require_current_user!, :only => [:show]
  before_filter :require_no_current_user!, :only => [:create, :new]
  
  def create
    @user = User.new(params[:user])
    if @user.save
      self.current_user = @user
      redirect_to user_url(@user)
    else
      redirect_to :back
    end
  end

  def new
    @user = User.new
    redirect_to users_url
  end

  def show
    if params.include?(:id)
      @user = User.find(params[:id])
    end
  end

end
