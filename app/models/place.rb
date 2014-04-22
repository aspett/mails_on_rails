class Place < ActiveRecord::Base

	@visited = false
	@path_from = nil

	def visited?
		@visited
	end

	def visited= v
		@visited = v
	end

	def self.reset_visited
		self.each{|p| p.visited=false}
	end

	def path_from
		@path_from
	end

	def path_from= pf
		@path_from = pf
	end
end
