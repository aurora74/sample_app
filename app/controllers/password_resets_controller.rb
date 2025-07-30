class PasswordResetsController < ApplicationController
  before_action :load_user, only: %i(edit update)
  before_action :check_reset_token, only: %i(edit update)
  before_action :check_reset_expiration, only: %i(edit update)
  before_action :load_user_by_email, only: %i(create)
  before_action :check_password, only: %i(update)

  # GET /password_resets/new
  def new; end

  # POST /password_resets
  def create
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t(".check_email_to_reset")
      redirect_to root_path
    else
      flash.now[:danger] = t(".email_not_found")
      render :new, status: :unprocessable_entity
    end
  end

  # GET /password_resets/:id/edit
  def edit; end

  # PATCH/PUT /password_resets/:id
  def update
    if @user.update(user_params)
      flash[:success] = t(".password_reset_success")
      @user.send_password_reset_confirmation_email
      log_out # Log out user immediately after sending confirmation email
      flash[:info] = t(".check_email_for_confirmation")
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(User::PASSWORD_RESET_PERMIT)
          .merge(reset_digest: nil)
  end

  def load_user
    @user = User.find_by(email: params[:email])
    return if @user

    flash[:danger] = t(".user_not_found")
    redirect_to root_path
  end

  def check_reset_token
    return if @user.authenticated?(:reset, params[:id])

    flash[:danger] = t(".invalid_reset_link")
    redirect_to root_path
  end

  def check_reset_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t(".reset_link_expired")
    redirect_to new_password_reset_path
  end

  def load_user_by_email
    @user = User.find_by(email: params.dig(:password_reset, :email)&.downcase)
    return if @user

    flash[:danger] = t(".email_not_found")
    redirect_to new_password_reset_path
  end

  def check_password
    return if params.dig(:user, :password).present?

    @user.errors.add(:password, t(".password_empty"))
    render :edit, status: :unprocessable_entity
  end
end
