module Authentication
  extend ActiveSupport::Concern

  AUTHENTICATION_COOKIE = :session_id
  RETURN_PATH_KEY = :return_to_after_authenticating

  included do
    before_action :require_authentication
    helper_method :authenticated?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private

  def authenticated?
    resume_authentication_session.present?
  end

  def require_authentication
    resume_authentication_session || request_authentication
  end

  def resume_authentication_session
    return @authentication_session if defined?(@authentication_session)

    candidate = find_authentication_session_by_cookie

    if candidate&.user&.active?
      Current.user = candidate.user
      @authentication_session = candidate
    else
      invalidate_authentication_session(candidate)
      @authentication_session = nil
    end
  end

  def find_authentication_session_by_cookie
    return if authentication_cookie_id.blank?

    Session.includes(:user).find_by(id: authentication_cookie_id)
  end

  def request_authentication
    if request.get? && (path = safe_local_path(request.fullpath))
      session[RETURN_PATH_KEY] = path
    end

    redirect_to new_session_path, alert: "Entre para continuar."
  end

  def start_new_session_for(user)
    return_path = safe_local_path(session.delete(RETURN_PATH_KEY)) || root_path
    previous_session = find_authentication_session_by_cookie

    reset_session

    authentication_session = Session.transaction do
      previous_session&.destroy!
      created_session = user.sessions.create!(
        user_agent: request.user_agent,
        ip_address: request.remote_ip
      )
      user.update!(last_sign_in_at: Time.current)
      created_session
    end

    @authentication_session = authentication_session
    Current.user = user
    write_authentication_cookie(authentication_session.id)

    return_path
  end

  def terminate_authentication_session
    resume_authentication_session&.destroy!
    @authentication_session = nil
    Current.user = nil
    reset_session
    clear_authentication_cookie
  end

  def invalidate_authentication_session(authentication_session)
    authentication_session&.destroy!
    Current.user = nil
    clear_authentication_cookie if authentication_cookie_id.present?
  end

  def authentication_cookie_id
    cookies.signed[AUTHENTICATION_COOKIE]
  end

  def write_authentication_cookie(session_id)
    cookies.signed[AUTHENTICATION_COOKIE] = authentication_cookie_options.merge(value: session_id)
  end

  def clear_authentication_cookie
    cookies.delete(AUTHENTICATION_COOKIE, **authentication_cookie_options)
  end

  def authentication_cookie_options
    {
      httponly: true,
      same_site: :lax,
      secure: Rails.env.production?
    }
  end

  def safe_local_path(path)
    return unless path.is_a?(String) && path.start_with?("/") && !path.start_with?("//")

    uri = URI.parse(path)
    path if uri.scheme.nil? && uri.host.nil?
  rescue URI::InvalidURIError
    nil
  end
end
