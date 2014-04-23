class BusinessManagementController < ApplicationController
  before_action :check_logged_in!

  def index
  end

  def figures
  end

  def logs
  	@business_events = BusinessEvent.all
  end
end
