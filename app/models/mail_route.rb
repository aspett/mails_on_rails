class MailRoute < ActiveRecord::Base
  before_create :set_to_active
  self.attribute_names.reject{|a|["id","created_at","updated_at","active"].include? a}.each do |a|
    validates_presence_of a
  end
  validate :validate_places_exist

  def origin
    begin
      Place.find(self.origin_id)
    rescue
      nil
    end
  end

  def destination
    begin
      Place.find(self.destination_id)
    rescue
      nil
    end
  end

  private

  def validate_places_exist
    if self.origin_id.is_a? String
      self.origin_id = Place.where(name: self.origin_id).id
      errors.add(:origin_id, "Origin does not exist") unless self.origin_id.present?
    else
      errors.add(:origin_id, "Origin does not exist") unless Place.where(id: self.origin_id).present?
    end

    if self.destination_id.is_a? String
      self.destination_id = Place.where(name: self.destination_id).id
      errors.add(:destination_id, "Destination does not exist") unless self.destination_id.present?
    else
      errors.add(:destination_id, "Destination does not exist") unless Place.where(id: self.destination_id).present?
    end
  end

  def set_to_active
    self.active = true
  end
end
