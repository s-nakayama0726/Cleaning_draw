class UserController < ApplicationController
  
  def new
  end
  
  def create
    user = CleaningEntry.new(user_params)
    user.join_flag = 0
    
    #既に割り当てられたナンバー以外の抽選ナンバーを割り当て
    users = CleaningEntry.all
    rand_num_arr = (1..100).to_a
    rand_num_arr.reject! do |num|
      search_result = CleaningEntry.where("draw_no = '#{num}'")
      search_result.size >= 1
    end
    user.draw_no = rand_num_arr.sample
    
    #登録ユーザー数が上限数の100を越えていた場合エラーを表示
    if users.size >= 100
      flash.now[:notice] = "登録数が100を超えています。これ以上新規登録はできません"
      render 'new' and return   
    end
    
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
    user = CleaningEntry.find(params[:id])
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