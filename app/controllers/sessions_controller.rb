class SessionsController < ApplicationController
  # GET /login
  def new; end

  # POST /login
  def create
    user = User.find_by(email: params.dig(:session, :email)&.downcase)
    if user&.authenticate(params.dig(:session, :password))
      reset_session
      log_in user
      remember_user_if_needed(user)
      flash[:success] = t(".login_success")
      redirect_to user
    else
      flash.now[:danger] = t(".login_failed")
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /logout
  def destroy
    log_out if logged_in?
    flash[:success] = t(".logout_success")
    redirect_to root_path
  end

  private

  def remember_user_if_needed user
    if params.dig(:session, :remember_me) == Settings.session.remember_me_value
      remember user
    else
      # Chỉ clear cookies, không clear remember_digest vì cần cho session authentication
      cookies.delete(:user_id)
      cookies.delete(:remember_token)
    end
  end
end
