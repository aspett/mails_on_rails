class MailsController < ApplicationController
  include ActionView::Helpers::OutputSafetyHelper
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
      attributes = m.attributes
      attributes["name"] = attributes["name"].gsub "'", "&quot;"
      attributes["company"] = attributes["company"].gsub "'", "&quot;"
      @route_data.push attributes.reject{|a| ["created_at", "updated_at"].include? a}
      required_places_ids.push m.origin_id, m.destination_id
    end

    @place_data = required_places_ids.uniq.map{|p| Place.find(p).attributes.reject{|a| ["created_at", "updated_at"].include? a}}
    @place_data.each{|p| p["name"] = p["name"].gsub "'", "&quot;"}
    @current_time = (Time.now + 12.hours).to_i

  end

  def show
    @mail = Mail.find(params[:id])
  end

  def edit
  end

  def new
    @mail = Mail.new
  end

  def create
    @mail = Mail.new(mail_params)
    # begin
      if @mail.save
        redirect_to mail_path(@mail), flash: {}
      else
        errors = @mail.errors.reject{|e,m| [:persisted_costs, :persisted_prices].include? e}
        flash[:error] = raw("There were #{errors.count} error(s):")
        errors.each do |e,m|
          if e == :base
            flash[:error] += raw("<br /> -- #{m}")
          else
            flash[:error] += raw("<br /> -- #{e.to_s} #{m}")
          end
        end
      end
    # rescue ActiveRecord::RecordInvalid
      # We need to manually catch this error for some reason
    # end
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
