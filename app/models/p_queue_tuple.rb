class PQueueTuple
  attr_accessor :start, :from, :from_route,  :cost_to_here
  def initialize start, from, from_route, costToHere
    @start = start
    @from = from
    @from_route = from_route
    @cost_to_here = costToHere
  end

end
