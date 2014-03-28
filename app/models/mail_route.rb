class MailRoute < ActiveRecord::Base
  def origin
    Place.find(@origin_id)
  end

  def destination
    Place.find(@destination_id)
  end
end
