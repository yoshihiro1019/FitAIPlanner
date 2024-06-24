class ProfilesController < ApplicationController
    before_action :set_user
  
    def show
    end
  
    def edit
    end
  
    def update
      if @user.update(user_params)
        flash[:success] = "ユーザーを更新しました"
        redirect_to profile_path
      else
        flash.now[:danger] = "ユーザーを更新出来ませんでした"
        render :edit, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_user
      @user = current_user
    end
  
    def user_params
        params.require(:user).permit(:email, :first_name, :last_name, :avatar)
      end
  end
  