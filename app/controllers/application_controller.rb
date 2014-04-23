class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception




  private

  def current_user
    user = User.where(id: session[:user_id]).first
    if !user.present?
      @current_user = nil
    else
      @current_user ||= user
    end
  end

  def check_is_manager
    if check_logged_in(true) && !current_user.is_manager?
      redirect_to :root, flash: { error: "Access denied" }
    end
  end

  def check_logged_in(enforce=false)
    unless current_user #No user
      redirect_to :login if enforce
      return false
    end
    true
  end

  def check_logged_in!
    check_logged_in(true)
  end

  helper_method :current_user
  helper_method :check_is_manager
  helper_method :check_logged_in
  helper_method :check_logged_in!


end
