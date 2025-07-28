class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(edit update destroy)
  before_action :load_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  # GET /users
  def index
    @pagy, @users = pagy(User.latest_first, items: Settings.pagy.page_10)
  end

  # GET /users/:id
  def show; end

  # GET /signup
  def new
    @user = User.new
  end

  # POST /signup
  def create
    @user = User.new(user_params)

    if @user.save
      log_in @user
      flash[:success] = t(".user_created_successfully")
      redirect_to @user
    else
      flash.now[:error] = t(".user_creation_failed")
      render :new, status: :unprocessable_entity
    end
  end

  # GET /users/:id/edit
  def edit; end

  # PATCH/PUT /users/:id
  def update
    if @user.update(user_params)
      flash[:success] = t(".user_updated_successfully")
      redirect_to @user
    else
      flash.now[:error] = t(".user_update_failed")
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    if @user.destroy
      flash[:success] = t(".user_deleted_successfully")
    else
      flash[:danger] = t(".delete_failed")
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit User::USER_PERMIT
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("application.please_log_in")
    redirect_to login_path
  end

  def load_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:danger] = t(".user_not_found")
    redirect_to root_path
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t("application.access_denied")
    redirect_to root_path
  end

  def admin_user
    return if current_user&.admin?

    flash[:danger] = t("application.admin_required")
    redirect_to root_path
  end
end
