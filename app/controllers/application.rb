# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #helper :all # include all helpers, all the time
  include AuthenticatedSystem
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '02753509b8ced36c5d4b893a511d2db8'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from ActionController::RoutingError, :with => :record_not_found
  rescue_from ActionController::UnknownController, :with => :record_not_found
  rescue_from ActionController::UnknownAction, :with => :record_not_found

  rescue_from ActiveRecord::RecordInvalid do |exception|
    flash[:notice] = "Sorry, there was a problem #{(exception.record.new_record? ? 'creating' : 'updating')} that"
    render :action => (exception.record.new_record? ? :new : :edit)
  end

  protected
  def record_not_found
    headers["Status"] = "404 Not Found"
    render :file => "#{RAILS_ROOT}/public/404.html"
  end
end
