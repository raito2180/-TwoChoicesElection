class ErrorsController < ApplicationController
  def bad_request
    render(status: :bad_request)
  end

  def unauthorized
    render(status: :unauthorized)
  end

  def forbidden
    render(status: :forbidden)
  end

  def not_found
    render(status: :not_found)
  end

  def internal_server_error
    render(status: :internal_server_error)
  end

  def bad_gateway
    render(status: :bad_gateway)
  end

  def service_unavailable
    render(status: :service_unavailable)
  end

  def gateway_timeout
    render(status: :gateway_timeout)
  end
end
