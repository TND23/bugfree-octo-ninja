class DepartmentsController < ApplicationController
  include DepartmentsHelper

  def show
    # we want to show: all users in the department as well as the current user
    @department = Department.find(params[:id])
    # for form helper
    @activity = Activity.new
    @users = @department.users
    @user = current_user
    respond_to do |format|
      format.html
      format.json { render json: @activity.as_json }
    end

  end

  def new
    @department = Department.new
  end

  def create
    # the only attribute that is accessible and required is dept_name
    @department = Department.new({:dept_name => params[:department][:dept_name], :user_id => current_user.id})
    @user = current_user
    if @department.save
      flash[:notice] = "Department #{@department.dept_name} was created successfully."
      redirect_to @department
    else
      flash[:warning] = "Something went wrong when trying to create #{params[:dept_name]} and it could not be created."
      redirect_to new_department_url
    end
  end

  def destroy

  end

  def index
    # we use the DepartmentsHelper to get the full list of all departments
    # we use this list to allow users to join departments
    @departments = current_user.departments
    respond_to do |format|
      format.html
      format.json do 
        activities_ls = add_depts_to_list(@departments)
        render json: activities_ls 
      end
    end
  end

  private

  def add_depts_to_list(departments)
    activities_ls = []
    @departments.each do |dept|
      activities_ls << dept.as_json
    end
    return activities_ls
  end
end