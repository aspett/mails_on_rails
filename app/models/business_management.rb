class BusinessManagement
  @route_to_cost = {}
  @route_to_price = {}


  private

  def collect_data
    Mail.all.each do |mail|
      
    end
  end

  def increment_key (key, value)
    @route_to_cost[key.to_s] = 0 if !@route_to_cost.has_key? key.to_s
    @route_to_cost[key.to_s] += value
    @route_to_price[key.to_s] = 0 if !@route_to_price.has_key? key.to_s
    @route_to_price[key.to_s] += value
  end
end
