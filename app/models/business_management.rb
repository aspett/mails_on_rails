class BusinessManagement
  def total_revenue
    collect_data if @route_to_cost.blank? or @route_to_price.blank?
    revenue = 0.0
    @route_to_price.each do |k,v|
      revenue += v
    end
    revenue
  end

  def total_expenditure
    collect_data if @route_to_cost.blank? or @route_to_price.blank?
    exp = 0.0
    @route_to_cost.each do |k,v|
      exp += v
    end
    exp
  end

  def total_routes_used
    @num_routes
  end

  def mail_volume
    collect_date if @mail_volume.blank?
    @mail_volume
  end

  def mail_weight
    collect_date if @mail_weight.blank?
    @mail_weight
  end

  def mail_number
    collect_date if @mail_number.blank?
    @mail_number
  end

  def average_times
    collect_data if @route_times.blank? or @route_durations.blank?
    average_times = {}
    @route_durations.each do |k,v|
    # {[Origin_ID, Destination_ID, Type, Priority] => Number of Times
      new_key = [Place.find(k[0]).name, Place.find(k[1]).name, k[2], ["Standard", "High"][k[3]]]
      average_times[new_key] = v.to_f / @route_times[k].to_f
    end
    average_times
  end


  private

  def collect_data
    @route_to_cost = {}
    @route_to_price = {}
    @route_times = {}
    @route_durations = {}
    @num_routes = 0
    @mail_volume = 0.0
    @mail_weight = 0.0
    @mail_number = 0


    Mail.all.each do |mail|
      @mail_volume += mail.volume
      @mail_weight += mail.weight
      @mail_number += 1
      (0...mail.routes.length).to_a.each do |i|
        increment_cost_price mail.routes[i], mail.prices[i], mail.costs[i]
        @num_routes += 1
        increment_delivery_time mail.routes[i]
      end
    end
  end

  def increment_cost_price (key, price, cost)
    @route_to_cost[key.to_s] = 0 if !@route_to_cost.has_key? key.to_s
    @route_to_cost[key.to_s] += cost
    @route_to_price[key.to_s] = 0 if !@route_to_price.has_key? key.to_s
    @route_to_price[key.to_s] += price
  end

  def increment_delivery_time (route)
    # {[Origin_ID, Destination_ID, Type, Priority] => Number of Times
    # {[Origin_ID, Destination_ID, Type, Priority] => Total time
    key = [route.origin_id, route.destination_id, route.transport_type, route.priority]
    @route_times[key] = 0 if !@route_times.has_key? key
    @route_durations[key] = 0 if !@route_durations.has_key? key
    @route_times[key] += 1
    @route_durations[key] += route.duration*60
  end
end
