class DepartmentsController < ApplicationController
  include DepartmentsHelper

  def show
    # we want to show: all users in the department as well as the current user
    @department = Department.find(params[:id])
    @users = @department.users
    @user = current_user
  end

  def new
    @department = Department.new
  end

  def create
    # the only attribute that is accessible and required is dept_name
    @department = Department.new({:dept_name => params[:department][:dept_name]})
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
  end
end