class MailRoutesController < ApplicationController
  before_action :check_logged_in!

  def index
    @active_mail_routes = MailRoute.where(active: true)
    @discontinued_mail_routes = MailRoute.where(active: false)


    matrix = []
    all_place_ids = []
    @active_mail_routes.each{|route| all_place_ids.push route.origin_id, route.destination_id }
    all_place_ids = all_place_ids.uniq
    all_places = all_place_ids.map{|id| Place.find(id)}
    
    @names = all_places.map{|p| p.name}
    @matrix = []
    all_places.each do |place|
      l_matrix = []
      all_places.each do |other|
        one_way = MailRoute.where(origin_id: place.id, destination_id: other.id)
        two_way = MailRoute.where(origin_id: other.id, destination_id: place.id)
        if one_way.count > 0 || two_way.count > 0
          l_matrix.push 1
        else 
          l_matrix.push 0
        end
      end
      @matrix.push l_matrix
    end

    @matrix = @matrix.to_json
  end

  def edit
    @mail_route = MailRoute.find(params[:id])
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
    if !@mail_route.active?
      flash[:error] = "You can not update a discontinud route."
      render :edit and return
    end

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

  def discontinue
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

  def recontinue
    @mail_route = MailRoute.find(params[:id])
    if @mail_route.try(:update_column, :active, true)
      b = BusinessEvent.new
      b.set_recontinue_values(@mail_route)
      b.save!
      redirect_to :mail_routes, flash: { success: "Successfully recontinued the route." }
    else
      flash[:error] = "There was an error recontinuing this route."
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
