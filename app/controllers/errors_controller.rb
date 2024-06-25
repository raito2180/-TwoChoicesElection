class ErrorsController < ApplicationController
  
  def bad_request
    render(:status => 400)
  end
  def unauthorized
    render(:status => 401)
  end
  def forbidden
    render(:status => 403)
  end
  def not_found
    render(:status => 404)
  end
  def internal_server_error
    render(:status => 500)
  end
  def bad_gateway
    render(:status => 502)
  end
  def service_unavailable 
    render(:status => 503)
  end

  def gateway_timeout
    render(:status => 504)
  end
end