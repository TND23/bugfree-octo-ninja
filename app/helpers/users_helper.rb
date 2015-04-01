module UsersHelper
  # created from custom custom RESTful route
  
  def add_department
    @department = Department.find_by_dept_name(params[:user][:departments])
    if @department.users.include?(current_user)
      flash[:warning] = "You are already a member of that department."
    else
      @department.add_user(current_user)
    end
    if @department.save
      redirect_to(:back)
    else
      render :json => @department, :status => :unprocessable_entity
    end
  end

end