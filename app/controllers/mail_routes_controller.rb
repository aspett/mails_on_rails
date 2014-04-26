class MailRoutesController < ApplicationController
  before_action :check_logged_in!

  def index
    @active_mail_routes = MailRoute.where(active: true)
    @discontinued_mail_routes = MailRoute.where(active: false)
  end

  def edit
    @mail_route = MailRoute.find(params[:id])
    if !@mail_route.active?
      redirect_to :mail_routes
    end

    b = BusinessManagement.new
    @profit = b.route_profits[@mail_route] || 0
    @revenue = b.route_revenue[@mail_route] || 0
    @expenditure = b.route_expenditure[@mail_route] || 0
    @average_time = b.average_times[[@mail_route.origin.name, @mail_route.destination.name, @mail_route.transport_type, @mail_route.priority_string]] || "No mail sent from given origin to destination by any route"
    @delivery_time = @mail_route.duration * 60
    @number_mail = b.route_mail_counts[@mail_route] || 0
    @is_slower = !@average_time.is_a?(String) && @average_time < @delivery_time ? "has-error" : "has-success"
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
      
      if(!@mail_route.previous_changes.empty?)
        #Save changes as a business event
        business_event = BusinessEvent.new
        business_event.set_route_values(@mail_route)
        business_event.save!
      end
      redirect_to :mail_routes, flash: { success: "Mail Route successfully updated." }
    else
      flash[:error] = "There was an error updating the Mail Route."
      render :edit
    end
  end

  def destroy
    @mail_route = MailRoute.find(params[:id])
    if @mail_route.update_column(:active, false)
      b = BusinessEvent.new
      b.set_discontinue_values(@mail_route)
      b.save!
      redirect_to :mail_routes, flash: { success: "Successfully discontinued the route, '#{@mail_route.name}'" }
    else
      flash[:error] = "There was an error discontinuing the route."
      render :edit
    end
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
