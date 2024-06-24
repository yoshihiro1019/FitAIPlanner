class ProfilesController < ApplicationController
    before_action :set_user
  
    def show
    end
  
    def edit
    end
  
    def update
      if @user.update(user_params)
        flash[:notice] = "ユーザーを更新しました"
        redirect_to profile_path
      else
        flash.now[:alert] = "ユーザーを更新出来ませんでした"
        render :edit
      end
    end
  
    private
  
    def set_user
      @user = current_user
    end
  
    def user_params
      params.require(:user).permit(:email, :name, :avatar)
    end
  end
  