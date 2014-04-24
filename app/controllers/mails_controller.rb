class MailsController < ApplicationController
  before_action :check_logged_in!

  def index
    @mails = Mail.all
    required_places_ids = []

    @mail_data = []
    Mail.all.each do |m|
      @mail_data.push m.to_hash
      required_places_ids.push m.origin_id, m.destination_id
    end
    @mail_data = Mail.all.map(&:to_hash)

    @route_data = []
    mr = MailRoute.all.select do |mr|
      show_route = false
      show_route = true if mr.active?
      Mail.all.each do |m|
        show_route = true if m.still_needs_route? mr
      end
      show_route
    end
    mr.each do |m|
      @route_data.push m.attributes.reject{|a| ["created_at", "updated_at"].include? a}
      required_places_ids.push m.origin_id, m.destination_id
    end

    @place_data = required_places_ids.uniq.map{|p| Place.find(p).attributes.reject{|a| ["created_at", "updated_at"].include? a}}
    @current_time = (Time.now + 12.hours).to_i

  end

  def show
  end

  def edit
    @mail = MailRoute.find(params[:id])
  end

  def new
    @mail = Mail.new
  end

  def create
    @mail = Mail.create(mail_params)
    if @mail.errors.messages.blank?
      redirect_to :mails
    end
  end

  def update
  end

  def delete
  end

  private

  def mail_params
    modified_params = origin_and_destination_from_string!
    modified_params.require(:mail).permit!
  end

  def origin_and_destination_from_string!
    mp = ActionController::Parameters.new params
    if mp[:mail]
      if mp[:mail][:origin_id]
        place = Place.where(name: mp[:mail][:origin_id])
        if place.present?
          mp[:mail][:origin_id] = place.first.id
        end
      end
      if mp[:mail][:destination_id]
        place = Place.where(name: mp[:mail][:destination_id])
        if place.present?
          mp[:mail][:destination_id] = place.first.id
        end
      end
    end
    mp
  end
end
