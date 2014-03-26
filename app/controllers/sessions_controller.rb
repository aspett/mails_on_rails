class SessionsController < ApplicationController
  layout "session"

  def create
    #Need a username and password from the form
    if params[:username] && params[:password]
      user = User.where(username: params[:username]).first
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to root_url, notice: "You're logged in fgt" and return
      else
        redirect_to login_path, flash: { error: "Invalid credentials" } and return
      end
    end
    redirect_to login_path
  end

  def delete
  end
end
