class MicropostsController < ApplicationController
  before_action :check_logged_in_user, only: %i(create destroy)
  before_action :load_micropost, only: %i(destroy)
  before_action :check_correct_user, only: %i(destroy)
  before_action :build_micropost, only: %i(create)

  # GET /microposts
  def index
    @pagy, @microposts = pagy(Micropost.newest, items: Settings.pagy.page_10)
    @micropost = current_user.microposts.build if logged_in?
  end

  # POST /microposts
  def create
    if @micropost.save
      flash[:success] = t(".micropost_created_successfully")
      redirect_to root_path
    else
      @pagy, @microposts = pagy(Micropost.newest, items: Settings.pagy.page_10)
      flash.now[:error] = t(".micropost_creation_failed")
      render :index, status: :unprocessable_entity
    end
  end

  # DELETE /microposts/:id
  def destroy
    if @micropost.destroy
      flash[:success] = t(".micropost_deleted_successfully")
    else
      flash[:error] = t(".micropost_deletion_failed")
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::MICROPOST_PERMIT
  end

  def build_micropost
    @micropost = current_user.microposts.build(micropost_params)
  end

  def load_micropost
    @micropost = current_user.microposts.find_by(id: params[:id])
    return if @micropost

    flash[:error] = t(".micropost_not_found")
    redirect_to root_path
  end

  def check_logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("application.please_log_in")
    redirect_to login_path
  end

  def check_correct_user
    return if @micropost.user == current_user

    flash[:error] = t("application.access_denied")
    redirect_to root_path
  end
end
