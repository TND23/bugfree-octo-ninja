class ActivitiesController < ApplicationController
  include ActivitiesHelper
  before_filter :require_current_user!

  def create
    @user = current_user
    safe_params = make_params
    @activity = Activity.new(safe_params)
    add_non_whitelisted_properties(@activity)
    if @activity.save
      if @activity.notify && @activity.status != "Completed"
        create_notice(@activity)
      end
      redirect_to activity_url(@activity)
    end
  end

  def update
    # when the ajax put is called in calendar.js, it wall pass thru a bunch of params
    # we find the activity that corresponds to the id param passed through

    @activity = Activity.find(params[:id])
    #  if it is a real activity

    if params[:activity]
      # and the Activity model is able to successfully update the attributes passed in for that activity by the ajax put
      # and saving the activity doesn't break things
      if @activity.update_attributes(params[:activity]) && @activity.save
        # then we render the updated attributes of our activity as json
        @activity.destroy_notices_if_completed(params[:activity][:status])
        render :json => @activity.as_json
        # if does not validate or save, show errors and go back
      else 
        # binding.pry
        flash[:error] = @activity.errors
        redirect_to :back
      end
    # If it isn't a real activity, render generic error
    else 
      respond_to do |format|
        format.js 
        format.json { render :json => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy
    # we need to redefine these variables because they are in the index html file
    # that is going to be rendered next
    @user = current_user
    @activities = current_user.activities
    render "index"
  end

  def new
    @user = current_user
    @activity = Activity.new
  end

  def index
    # unless searching for all
    # if params[:activities][:searching_for] =! '*'
    # we do not use Activity.where(:user_id => current_user.id) because we want to be able to look
    # at other users calendars.
    # else @activites = Activity.all
    @activities = Activity.where(:user_id => params["user_id"]).all
    @user = current_user
    respond_to do |format|
      format.html
      format.csv {send_data Activity.to_csv(@activities) }
      format.json { render :json => @activities.as_json }
    end
    
  end
  
  def show
    @activity = Activity.find(params[:id])
     respond_to do |format|
      format.html
      format.json { render json: @activity.as_json }
    end
  end

  def edit
    @activity = Activity.find(params[:id])
  end


end
