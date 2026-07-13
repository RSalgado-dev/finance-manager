class RequestContextTestController < ApplicationController
  allow_unauthenticated_access

  class_attribute :observed_context

  def show
    self.class.observed_context = current_snapshot
    head :no_content
  end

  def failure
    self.class.observed_context = current_snapshot
    raise "falha controlada no contexto de request"
  end

  private

  def current_snapshot
    {
      user: Current.user,
      company: Current.company,
      membership: Current.membership,
      request_id: Current.request_id,
      ip_address: Current.ip_address,
      user_agent: Current.user_agent
    }
  end
end
