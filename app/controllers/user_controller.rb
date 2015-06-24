class UserController < ApplicationController
  def new
  end
  
  def create
    user = CleaningEntry.new(user_params)
    user.join_flag = 0
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
  
  def switch
    @user = CleaningEntry.find(params[:user][:id])
    if params[:commit] == '削除'
      redirect_to user_delete_path(@user)
    else
      redirect_to edit_user_path(@user)
    end  
  end
  
  def delete
    user = CleaningEntry.find(params[:format])
    message = user.name+"さんの情報が削除されました"
    user.destroy

    redirect_to user_index_path, notice: message
  end
  
  def edit
    @user = CleaningEntry.find(params[:id])
  end
  
  def update
    user = CleaningEntry.find(params[:id])
    user.name = params[:user][:name]
    user.user_id = params[:user][:user_id]
    user.pass = params[:user][:pass]
    
    user.save
    if user.errors.count == 0
      flash.now[:notice] = user.name+"さんのユーザー情報登録が完了しました"
    else
      flash.now[:notice] = user.errors.full_messages[0]
    end
    redirect_to user_index_path
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :user_id, :pass)
  end
end