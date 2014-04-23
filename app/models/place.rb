class Place < ActiveRecord::Base
  attr_accessor :path_from_route
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

  def to_s
    self.name
  end

end
