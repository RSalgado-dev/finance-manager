class AuthenticationTestController < ApplicationController
  allow_unauthenticated_access only: %i[seed_rails_session seed_unsafe_return]

  class_attribute :observed_context

  def show
    self.class.observed_context = current_snapshot
    render plain: "Autenticado como #{Current.user.name}"
  end

  def failure
    self.class.observed_context = current_snapshot
    raise "falha controlada após autenticação"
  end

  def seed_rails_session
    session[:pre_authentication_marker] = "old-session"
    head :no_content
  end

  def seed_unsafe_return
    session[Authentication::RETURN_PATH_KEY] = params[:path]
    head :no_content
  end

  private

  def current_snapshot
    {
      user: Current.user,
      company: Current.company,
      membership: Current.membership,
      request_id: Current.request_id,
      ip_address: Current.ip_address,
      user_agent: Current.user_agent,
      authentication_session_id: cookies.signed[Authentication::AUTHENTICATION_COOKIE],
      pre_authentication_marker: session[:pre_authentication_marker]
    }
  end
end
