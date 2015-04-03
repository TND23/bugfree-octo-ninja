class ActivitiesController < ApplicationController
  include ActivitiesHelper
  before_filter :require_current_user!

  def create
    @user = current_user
    safe_params = make_params
    @activity = Activity.new(safe_params)
    @activity.add_tags
    @activity.user = @user
    @activity.tagged = tagged?
    if @activity.save
      redirect_to activity_url(@activity)
    end
  end

  def update
    @activity = Activity.find(params[:id])
    if params[:activity]
      if @activity.update_attributes(params[:activity])
        if @activity.save 
           redirect_to activity_url(@activity)
        end
      end
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
  end

  def new
    @user = current_user
    @activity = Activity.new
  end

  def index
    @user = current_user
    # unless searching for all
    # if params[:activities][:searching_for] =! '*'
    # we do not use Activity.where(:user_id => current_user.id) because we want to be able to look
    # at other users calendars.
    @activities = Activity.where(:user_id => params[:user_id]).all
    # else @activites = Activity.all
    respond_to do |format|
      format.html
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
