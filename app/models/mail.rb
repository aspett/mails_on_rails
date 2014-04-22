class Mail < ActiveRecord::Base
  has_many :mail_state
  validate :allocate_route
  before_save :calculate_price_cost
  before_save :format_routes
  after_save :create_states
  self.attribute_names.reject{|a|["id","created_at","updated_at","sent_at","received_at","waiting_time","cost","price","routes_array"].include? a}.each do |a|
    validates_presence_of a
  end

  def priority_string
    ["Standard", "High"][self.priority]
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

  def sent_time
    if self.mail_states && self.mail_states.length >= 2
      if (Time.current + 12.hours) > self.mail_states[1].start_time
        return self.mail_states[1].start_time.to_s(:db)
      end
    end
    nil
  end

  def received_time
    if self.mail_states && self.mail_states.length >= 2
      if (Time.current + 12.hours) > self.mail_states.last.start_time
        return self.mail_states.last.start_time.to_s(:db)
      end
    end
    nil
  end

  def mail_states
    self.mail_state
  end

  def routes
    self.routes_array ||= ""
    @routes ||= self.routes_array.split(",")
    @routes.map {|r| MailRoute.find(r)}
  end

  def routes=(val) #Array of routes
    @routes = val
  end

  def mail_routes
    format_routes
    self.routes_array
  end

  def format_routes
    self.routes_array = routes.map{|r| r.id}.join(",")
  end

  def allocate_route
    if @routes.blank?
      #Reset all places to visted = false
      if self.origin_id == self.destination_id
        errors.add(:destination_id, "can't have same destination as origin") and return
      end
      all_places = Place.all
      all_places.each {|p| p.visited = false}

      #Find the routes that begin with the mail's origin 
      all_routes = MailRoute.all 
      routes_im_dealing_with = all_routes.select{|route| route.origin_id == self.origin_id}

      #initialise priority queue with appropriate routes using the heuristic associate with priority. 0 = low = price, 1 = high = speed
      start = all_places.select{|place| place.id == self.origin_id}.first
      pQueue = PQueue.new([PQueueTuple.new(start, nil, nil, 0)]){|a,b| a.cost_to_here < b.cost_to_here}

      goal = nil

      while !pQueue.empty? do
        tuple = pQueue.pop
        if(!tuple.start.visited?)
          tuple.start.visited = true
          tuple.start.path_from = tuple.from
          tuple.start.path_from_route = tuple.from_route

          if(tuple.start.id == self.destination_id)

            goal = tuple.start
          end

          routes_im_dealing_with = all_routes.select{|route| route.origin_id == tuple.start.id}
          routes_im_dealing_with.each do |route|
            destination = all_places.select{|place| place.id == route.destination_id}.first
            if(!destination.visited?)
              if(self.priority == 0)
                route_cost = route.price(self)
              else
                route_cost = route.next_receival
              end
              cost_to_neigh = tuple.cost_to_here + route_cost
              pQueue.push(PQueueTuple.new(destination, tuple.start, route, cost_to_neigh))
            end
          end
        end        
      end 

      # Collect route in to array
      if goal.nil?
        errors.add(:origin_id, "there is no route from that origin to destination")
        errors.add(:destination_id, "there is no route from that origin to destination")
        return false
      end
      current = goal
      route = []
      until current.path_from.nil?
        route.push current.path_from_route
        current = current.path_from
      end
      route = route.reverse
      self.routes = route
    end
  end


  def current_state
    self.mail_state.select{|state| (Time.now + 12.hours) > state.start_time}.last
  end

  def current_location
    if self.routes.length > 0
      if current_state.routing_step >= self.routes.length
        return self.routes.last.destination
      end

      if current_state.routing_step < 0
        return nil
      end

      self.routes[current_state.routing_step].origin
    end
  end

  private

  def calculate_price_cost
    cost = 
    price = 0

    if @routes
      @routes.each do |r|
        cost += r.cost(self)
        price += r.price(self)
      end
    end

    self.cost = cost
    self.price = price
  end

  def create_states
    i = 0
    current_time = (Time.now + 12.hours).to_i
    MailState.where(mail_id: self.id).each{|s|s.delete}
    self.routes.each do |route|
      #Waiting state until departure
      start_time = current_time
      end_time = start_time + (route.next_receival_from_time(start_time))
      MailState.create({
        current_location_id: route.origin_id,
        next_destination_id: route.destination_id,
        routing_step: i,
        state_int: 0,
        mail_id: self.id,
        start_time: Time.at(start_time),
        end_time: Time.at(end_time)
      })
      current_time = end_time
      start_time = current_time
      end_time = start_time + route.duration * 60
      #In transit
      MailState.create({
        current_location_id: route.origin_id,
        next_destination_id: route.destination_id,
        routing_step: -1,
        state_int: 1,
        mail_id: self.id,
        start_time: Time.at(start_time),
        end_time: Time.at(end_time)
      })
      i += 1
      current_time = end_time
      start_time = current_time
      #Are we done yet?
      if route.destination_id == self.destination_id
        MailState.create({
          current_location_id: route.origin_id,
          next_destination_id: route.destination_id,
          routing_step: i,
          state_int: 2,
          mail_id: self.id,
          start_time: Time.at(start_time),
          end_time: nil
        })
      end
    end
  end
end
