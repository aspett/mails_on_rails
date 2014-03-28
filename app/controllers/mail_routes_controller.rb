class MailRoutesController < ApplicationController
  def index
    @mail_routes = MailRoute.all
  end

  def show
  end

  def edit
  end

  def new
  end

  def delete
  end
end
