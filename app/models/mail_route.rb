class MailRoute < ActiveRecord::Base
  def origin
    Place.find(self.origin_id)
  end

  def destination
    Place.find(self.destination_id)
  end
end
