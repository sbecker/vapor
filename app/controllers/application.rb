# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '77ad623625b2138d3e161d8fcd7808a4'
  
  filter_parameter_logging :password, :salt, :aws_access_key, :aws_secret_access_key, :aws_x_509_key, :aws_x_509_certificate
end
