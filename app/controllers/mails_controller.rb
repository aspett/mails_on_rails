class MailsController < ApplicationController
  before_action :check_logged_in!

  def index
    @mails = Mail.all
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
