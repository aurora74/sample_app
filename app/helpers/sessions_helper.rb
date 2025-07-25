module SessionsHelper
  # Logs in the given user
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    return unless session[:user_id]

    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  # Logs out the current user
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
