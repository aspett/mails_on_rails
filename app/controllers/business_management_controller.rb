class BusinessManagementController < ApplicationController
  before_action :check_logged_in!

  def index
  end

  def figures
    b = BusinessManagement.new
    @total_revenue = b.total_revenue
    @total_expenditure = b.total_expenditure
    @total_events = b.total_routes_used #+ other events
    @mail_number = b.mail_number
    @mail_volume = b.mail_volume
    @mail_weight = b.mail_weight
    @average_times = b.average_times
  end

  def logs
  end
end
