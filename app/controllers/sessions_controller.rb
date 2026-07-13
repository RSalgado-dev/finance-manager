class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  layout "public"

  def new
    redirect_to root_path if authenticated?
  end

  def create
    credentials = session_params.to_h
    credentials["email"] = credentials.fetch("email", "").strip.downcase
    user = User.authenticate_by(credentials)

    if user&.active?
      redirect_to start_new_session_for(user), notice: "Login realizado com sucesso."
    else
      redirect_to new_session_path, alert: "E-mail ou senha inválidos."
    end
  end

  def destroy
    terminate_authentication_session
    redirect_to root_path, notice: "Sessão encerrada com sucesso.", status: :see_other
  end

  private

  def session_params
    params.permit(:email, :password)
  end
end
