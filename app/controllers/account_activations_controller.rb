class AccountActivationsController < ApplicationController
  before_action :load_user_by_email
  before_action :check_user_authentication
  before_action :check_user_activation

  # GET /account_activations/:id/edit
  def edit
    @user.activate
    log_in @user
    flash[:success] = t(".account_activated")
    redirect_to @user
  end

  private

  def load_user_by_email
    @user = User.find_by(email: params[:email])
    return if @user

    flash[:danger] = t(".invalid_activation_link")
    redirect_to root_path
  end

  def check_user_authentication
    return if @user&.authenticated?(:activation, params[:id])

    flash[:danger] = t(".invalid_activation_link")
    redirect_to root_path
  end

  def check_user_activation
    return unless @user&.activated?

    flash[:info] = t(".account_already_activated")
    redirect_to root_path
  end
end
