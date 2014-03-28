class Mail < ActiveRecord::Base
  has_one :mail_state
  before_save :format_routes
  def routes
    @mail_routes ||= ""
    @routes ||= @mail_routes.split(",")
    @routes.map {|r| MailRoute.find(r)}
  end

  def routes=(val) #Array of routes
    @routes = val
  end

  def mail_routes
    format_routes
    @mail_routes
  end

  private

  def format_routes
    @mail_routes = routes.map{|r| r.id}.join(",")
  end
end
