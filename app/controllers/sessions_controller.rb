class SessionsController < ApplicationController
  before_action :find_user, only: %i(create)
  before_action :check_user_authentication, only: %i(create)
  before_action :check_user_activation, only: %i(create)

  # GET /login
  def new; end

  # POST /login
  def create
    reset_session
    log_in @user
    remember_user_if_needed(@user)
    flash[:success] = t(".login_success")
    redirect_back_or @user
  end

  # DELETE /logout
  def destroy
    log_out if logged_in?
    flash[:success] = t(".logout_success")
    redirect_to root_path
  end

  # GET /logout_and_login
  def logout_and_login
    log_out if logged_in?
    flash[:info] = t(".password_changed_please_login")
    redirect_to login_path
  end

  private

  def find_user
    @user = User.find_by(email: params.dig(:session, :email)&.downcase)
    return if @user

    flash.now[:danger] = t(".user_not_found")
    render :new, status: :unprocessable_entity
  end

  def check_user_authentication
    return if @user&.authenticate(params.dig(:session, :password))

    flash.now[:danger] = t(".login_failed")
    render :new, status: :unprocessable_entity
  end

  def check_user_activation
    return if @user.activated?

    flash[:warning] = t(".account_not_activated")
    redirect_to root_path
  end

  def remember_user_if_needed user
    if params.dig(:session, :remember_me) == Settings.session.remember_me_value
      remember user
    else
      # Only clear cookies, do not clear remember_digest
      cookies.delete(:user_id)
      cookies.delete(:remember_token)
    end
  end
end
