class UserController < ApplicationController
  def new
    @user = CleaningEntry.new
  end
  
  def create
    @user = CleaningEntry.new
    @user.name = params[:user][:name]
    
    flash.now[:notice] = @user.name+"さんのユーザー情報登録が完了しました"
    @user.save
    render 'new'
  end
  
  def index
    @user = CleaningEntry.all
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
    @user = CleaningEntry.find(id)
    @user.destroy
    
    session[:user] = nil
    redirect_to user_index_path, notice: @user.name+'さんのユーザー情報削除が完了しました'
  end
  
  def edit
    @user = CleaningEntry.find(params[:id])
  end
  
  def update
    @user = CleaningEntry.find(params[:id])
    @user.name = params[:user][:name]
    
    @user.save
    render 'edit',notice: @user.name+'さんのユーザー情報が更新されました'
  end
end
