class NoticesController < ApplicationController
  
  def index
    @notices = current_user.notices
  end

  def show
    
  end

  def create
    
  end

  def destroy
    
  end

  def new
    
  end

end