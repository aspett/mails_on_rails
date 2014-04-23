class BusinessEvent < ActiveRecord::Base
	include ActionView::Helpers::OutputSafetyHelper
  include ActionView::Helpers::NumberHelper
	
  def set_route_values(mail_route)
		self.date = Time.current + 12.hours
		self.event_type = 0
		self.details = details_route_string(mail_route)
		
	end

  def set_mail_values(mail)
    self.date = Time.current + 12.hours
    self.event_type = 1
    self.details = details_mail_string(mail)
  end

  def set_discontinue_values(mail_route)
    self.date = Time.current + 12.hours
    self.event_type = 2
    self.details = details_discontinue_string(mail_route)
  end

	private

	def details_mail_string(mail)
    "New Mail: ID: '#{mail.id}', Origin: '#{mail.origin.name}', Destination: '#{mail.destination.name}', Priority: '#{mail.priority_string}', Cost: '#{number_to_currency mail.cost}', Price: '#{number_to_currency mail.price}', Weight: '#{mail.weight}', Volume: '#{mail.volume}'"
	end

  def details_route_string(mail_route)
    rejections = ["id", "transport_type", "priority", "origin_id", "destination_id", "duration", "frequency", "start_date" ,"created_at", "updated_at"]
    changes = "Route ID: '#{mail_route.id}'. Changed: "
    mail_route.previous_changes.reject{|a| rejections.include? a}.each do |k,v|
          changes <<"#{k}: '#{v[0]}' -> '#{v[1]}', "
    end
    changes[0..-3]
  end

  def details_discontinue_string(mail_route)
    attributes = ["name", "origin", "destination", "company"]
    str = "Route ID: '#{mail_route.id}'. Discontinued: "
    attributes.each do |attr_name|
      str << "#{attr_name}: '#{mail_route.send(attr_name)}', "
    end
    str[0..-3]
  end
end