class MailRoutesController < ApplicationController
  before_action :check_logged_in!

  def index
    @mail_routes = MailRoute.all
  end

  def edit
    @mail_route = MailRoute.find(params[:id])
  end

  def new
    @mail_route = MailRoute.new(start_date: DateTime.now.at_beginning_of_day + 12.hours)
  end

  def create
    @mail_route = MailRoute.create(mr_params)
    if @mail_route.errors.messages.blank?
      redirect_to :mail_routes
    else
      puts "hi"
    end
  end

  def update
    @mail_route = MailRoute.find(params[:id])
    if @mail_route.update_attributes(mr_params)
      redirect_to :mail_routes, flash: { success: "Mail Route successfully updated." }
    else
      flash[:error] = "There was an error updating the Mail Route."
      render :edit
    end
  end

  def delete
  end

  private

  def mr_params #Strong parameters / mail route params
    modified_params = origin_and_destination_from_string!
    modified_params.require(:mail_route).permit!
  end

  def origin_and_destination_from_string!
    mp = ActionController::Parameters.new params
    if mp[:mail_route]
      if mp[:mail_route][:origin_id]
        place = Place.where(name: mp[:mail_route][:origin_id])
        if place.present?
          mp[:mail_route][:origin_id] = place.first.id
        end
      end
      if mp[:mail_route][:destination_id]
        place = Place.where(name: mp[:mail_route][:destination_id])
        if place.present?
          mp[:mail_route][:destination_id] = place.first.id
        end
      end
    end
    mp
  end
end
