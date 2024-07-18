class ApplicationController < ActionController::Base
  before_action :require_login
  add_flash_types :success, :danger

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    return if current_user

    flash[:danger] = t('defaults.flash_message.require_login')
    redirect_to login_path
  end

  def not_authenticated
    redirect_to login_path, danger: t('defaults.flash_message.require_login')
  end
end
