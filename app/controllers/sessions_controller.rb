class SessionsController < ApplicationController

  def create
    user = User.find_by_credentials(params[:user][:username], params[:user][:password])
    if user.nil?
      flash[:warning] = "Username or password was incorrect"
      redirect_to new_session_url
    else
      self.current_user = user
      redirect_to user_url(user)
    end
  end

  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to new_session_url
  end

  def new
    
  end

end