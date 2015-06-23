class UserController < ApplicationController
  def new
  end
  
  def create
    user = CleaningEntry.new(user_params)
    user.name = params[:user][:name]
    user.user_id = params[:user][:user_id]
    user.pass = params[:user][:pass]
    user.save
    if user.errors.count == 0
      flash.now[:notice] = user.name+"さんのユーザー情報登録が完了しました"
    else
      flash.now[:notice] = "既に登録されているユーザーIDです"
    end 
    render 'new'
  end
  
  def index
    @users = CleaningEntry.all
  end
  
  def switch
    @user = CleaningEntry.find(params[:user][:id])
    if params[:commit] == '削除'
      session[:user_id] = @user.id
      redirect_to user_delete_path
    else
      redirect_to edit_user_path(@user)
    end  
  end
  
  def delete
    id = session[:user_id]
    user = CleaningEntry.find(id)
    user.destroy
    
    session[:user] = nil
    redirect_to user_index_path, notice: user.name+'さんのユーザー情報削除が完了しました'
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
    redirect_to user_index_path,  notice: user.name+'さんのユーザー情報が更新されました'
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :user_id, :pass)
  end
end