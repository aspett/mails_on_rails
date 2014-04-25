class PQueueTuple
  attr_accessor :start, :from, :from_route,  :cost_to_here
  def initialize start, from, from_route, costToHere
    @start = start
    @from = from
    @from_route = from_route
    @cost_to_here = costToHere
  end

  def cost_compared_to(other)
  	if(self.cost_to_here < other.cost_to_here)
  		return -1
  	elsif(self.cost_to_here == other.cost_to_here)
  		self_route = nil
      other_route = nil

      if !self.from_route.nil?
  			self_route = MailRoute.find(self.from_route)
      else
        return -1
  		end
      
      if self_route.nil?
        return -1
      end

      if other_route.nil?
        return -1
      end

      if (self_route.maximum_weight*self_route.maximum_volume) - ([self_route.maximum_weight, self_route.maximum_volume].max - [self_route.maximum_weight, self_route.maximum_volume].min) <= (other_route.maximum_weight*other_route.maximum_volume) - ([other_route.maximum_weight, other_route.maximum_volume].max - [other_route.maximum_weight, other_route.maximum_volume].min) 
        return -1
      else
        return 1
      end
    end
    return 1
  end

end
