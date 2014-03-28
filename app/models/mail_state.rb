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
    ["Waiting", "In Transit", "Delivered"][@state_int]
  end
end
