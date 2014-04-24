class HomeController < ApplicationController
  def index
    render 'index'
  end

  def generate
    @places = Place.all
  end
end
