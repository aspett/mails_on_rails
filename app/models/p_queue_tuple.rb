class PQueueTuple
	attr_accessor :start, :from, :cost_to_here
	def initialize start, from, costToHere
		@start = start
		@from = from
		@cost_to_here = costToHere
	end

end
