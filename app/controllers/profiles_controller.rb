class ProfilesController < ApplicationController
  before_action :set_user
   # レイアウトを指定

  def app_page
    # app_layout.html.erb をレンダリングするためのアクション
  end

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = I18n.t('flash.success.profile_update')
      redirect_to profile_path
    else
      flash.now[:danger] = I18n.t('flash.danger.profile_update_failed')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :avatar, :avatar_cache, :address)
  end
end
