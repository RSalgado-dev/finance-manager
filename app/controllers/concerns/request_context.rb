module RequestContext
  extend ActiveSupport::Concern

  included do
    around_action :with_request_context
  end

  private

  def with_request_context
    Current.reset

    Current.set(
      request_id: request.request_id,
      ip_address: request.remote_ip,
      user_agent: request.user_agent
    ) { yield }
  ensure
    Current.reset
  end
end
