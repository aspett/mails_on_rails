class HomeController < ApplicationController
  def index
    if current_user.nil?
      redirect_to login_path and return
    end
    render 'index'
  end

  def generate
    @places = Place.all
  end
end
