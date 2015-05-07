class DepartmentActivitiesController < ApplicationController
  def index
    @activity = Activity.new
    @activities = Activity.where(:department_id => params[:department_id])
    # respond with a form to create a new department activity or 
    # the json value we want when fetching
    respond_to do |format|
      format.html
      format.json { render :json => @activities.as_json }
    end
    # activity.department_id = params[:department_id] if params[:activity][:department_id]
    # add_activity_to_dept(activity) if activity.department_id
  end

  def show
    @activity = Activity.where("department_id = ? AND id = ?", params[:department_id], params[:id]).first
    respond_to do |format|
      format.html
      format.json { render :json => @activity.as_dept_json }
    end
  end

  private

    def show_department_activities(department_id)
    dept = Department.find(department_id)
    @activities = dept.activities

    return @activities
  end

    def add_activity_to_dept(activity)
    if params[:activity][:department_id]
      dept = Department.find(params[:activity][:department_id].to_i) 
      activity.department = dept
      dept.activities << activity
    end
  end
end