class SessionsController < ApplicationController
  layout "session"

  def create
    #Need a username and password from the form
    if params[:username] && params[:password]
      user = User.where(username: params[:username]).first
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to root_url, flash: { success: "You have been logged in" } and return
      else
        redirect_to login_path, flash: { error: "Invalid credentials" } and return
      end
    end
    redirect_to login_path
  end

  def delete
    if current_user
      session[:user_id] = nil
      redirect_to root_url, flash: { notice: "You have been logged out" } and return
    end
    redirect_to root_url
  end
end
