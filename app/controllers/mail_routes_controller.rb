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
    else
      debugger
      puts "hi"
    end
  end

  def delete
  end

  private

  def mr_params
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
        else
          mp[:mail_route][:origin_id] = Place.create(name: mp[:mail_route][:origin_id]).id
        end
      end
      if mp[:mail_route][:destination_id]
        place = Place.where(name: mp[:mail_route][:destination_id])
        if place.present?
          mp[:mail_route][:destination_id] = place.first.id
        else
          mp[:mail_route][:destination_id] = Place.create(name: mp[:mail_route][:destination_id]).id
        end
      end
    end
    mp
  end
end
