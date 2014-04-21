class MailRoute < ActiveRecord::Base
  self.attribute_names.each do |a|
    validates_presence_of a
  end
  validate :validate_places_exist

  def origin
    Place.find(self.origin_id)
  end

  def destination
    Place.find(self.destination_id)
  end

  private

  def validate_places_exist
    unless Place.where(id: self.origin_id).present?
      errors.add(:origin_id, "Origin does not exist")
    end
    unless Place.where(id: self.destination_id).present?
      errors.add(:destination_id, "Destination does not exist")
    end
  end
end
