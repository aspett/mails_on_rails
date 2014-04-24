class MailState < ActiveRecord::Base
  belongs_to :mail

  def current_location
    Place.find(@current_location_id)
  end

  def next_destination
    Place.find(@next_destination_id)
  end

  def previous_destination
    Place.find(@previous_destination_id)
  end

  def state
    ["Waiting", "In Transit", "Delivered"][self.state_int]
  end

  def to_hash
    hash = self.attributes.reject{|a| ["created_at", "updated_at"].include? a}
    hash["start_time"] = hash["start_time"].to_i
    hash["end_time"] = hash["end_time"].to_i
    hash["full_duration"] = end_time.to_i - start_time.to_i
    hash["current_duration"] = ((Time.current + 12.hours) - start_time)
    hash["current_duration"] = [hash["current_duration"],hash["full_duration"]].min
    hash
  end
end
