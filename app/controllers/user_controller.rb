class UserController < ApplicationController
  
  def new
  end
  
  def create
    user = CleaningEntry.new(user_params)
    user.join_flag = 0
    user.join_count = 0
    user.hit_count = 0
    user.rate = 0
    user.save
    
    if user.errors.count == 0
      flash.now[:notice] = user.name+"さんのユーザー情報登録が完了しました"
    else
      flash.now[:notice] = user.errors.full_messages[0]
    end 
    render 'new'
  end
  
  def index
    @users = CleaningEntry.all
  end
  
  def destroy
    user = CleaningEntry.where(id: params[:id])[0]
    message = user.name+"さんの情報が削除されました"
    user.destroy

    redirect_to user_index_path, notice: message
  end
  
  def edit
    @user = CleaningEntry.find(params[:id])
  end
  
  def update
    user = CleaningEntry.find(params[:id])
    user.update(user_params)
    
    if user.errors.count == 0
      message = user.name+"さんのユーザー情報が更新されました"
    else
      message = user.errors.full_messages[0]
    end
    redirect_to user_index_path, notice: message
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :user_id, :pass, :email)
  end
end