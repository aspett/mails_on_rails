class MailRoutesController < ApplicationController
  def index
    @mail_routes = MailRoute.all
  end

  def show
  end

  def edit
  end

  def new
    @mail_route = MailRoute.new
  end

  def create
    @mail_route = MailRoute.create(mr_params)
    if @mail_route.errors.messages.blank?
      redirect_to :mail_routes
    end
  end

  def delete
  end

  private

  def mr_params
    params.require(:mail_route).permit!
  end
end
