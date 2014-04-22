class Mail < ActiveRecord::Base
  has_one :mail_state
  before_save :allocate_route
  before_save :format_routes
  self.attribute_names.reject{|a|["id","created_at","updated_at","sent_at","received_at","waiting_time","cost","price","routes_array"].include? a}.each do |a|
    validates_presence_of a
  end

  def origin
    begin
      Place.find(self.origin_id)
    rescue
      nil
    end
  end

  def destination
    begin
      Place.find(self.destination_id)
    rescue
      nil
    end
  end

  def routes
    @mail_routes ||= ""
    @routes ||= @mail_routes.split(",")
    @routes.map {|r| MailRoute.find(r)}
  end

  def routes=(val) #Array of routes
    @routes = val
  end

  def mail_routes
    format_routes
    @mail_routes
  end


  def allocate_route

    #Reset all places to visted = false
    all_places = Place.all
    all_places.each {|p| p.visited = false}

    #Find the routes that begin with the mail's origin 
    all_routes = MailRoute.all 
    routes_im_dealing_with = all_routes.select{|route| route.origin_id == self.origin_id}

    #initialise priority queue with appropriate routes using the heuristic associate with priority. 0 = low = price, 1 = high = speed
    start = all_places.select{|place| place.id == self.origin_id}.first
    pQueue = PQueue.new([PQueueTuple.new(start, nil, 0)]){|a,b| a.cost_to_here < b.cost_to_here}

    goal = nil

    while !pQueue.empty? do
      tuple = pQueue.pop
      if(!tuple.start.visited?)
        tuple.start.visited = true
        tuple.start.path_from = tuple.from

        debugger
        if(tuple.start.id == self.destination_id)

          goal = tuple.start
        end

        routes_im_dealing_with = all_routes.select{|route| route.origin_id = tuple.start.id}
        routes_im_dealing_with.each do |route|
          destination = all_places.select{|place| place.id = route.destination_id}.first
          if(!destination.visited?)
            if(self.priority == 0)
              route_cost = route.price(self)
            else
              route_cost = route.next_receival
            end
            cost_to_neigh = tuple.cost_to_here + route_cost
            pQueue.push(PQueueTuple.new(destination, tuple.start, cost_to_neigh))
          end
        end
      end        
    end 
    debugger
    puts "hi"
  end

  def format_routes
    @mail_routes = routes.map{|r| r.id}.join(",")
  end
end
