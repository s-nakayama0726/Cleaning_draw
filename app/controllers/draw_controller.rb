#coding: utf-8

class DrawController < ApplicationController
  before_action :set_users_draw_info_get, only: [:user_index, :user_result, :user_show, :already_draw_user_list]
  
  def already_draw_user_list
    @all_users_number, @already_entry_users_number = CleaningEntry.user_count
  end
  
  def user_index
    #ログイン判断（session[:id]に値が入っているかどうか）
    #既にエントリーが済んでいるなら(join_flag==1なら）user_already_result画面に遷移、済んでいないならuser_show画面に遷移
    if session[:id] != nil
      if CleaningEntry.where(id: session[:id])[0].join_flag == 1
        @entry = CleaningEntry.where(id: session[:id])[0]
        @all_users_number, @already_entry_users_number = CleaningEntry.user_count
        render 'user_already_result' and return
      else
        render 'user_show'
      end
    end    
  end
  
  def user_result
    @entry = CleaningEntry.where(id: session[:id])[0]
    @entry.join_flag = 1
    @entry.hit_rate_get
    @entry.join_count_add
    @entry.save
    
    #全員の抽選が確認できたらその時点で抽選実行を行う(3人以上登録されているとき)
    draw_result = DrawResult.where(id: 1)[0]
    if draw_result.result_flag == 0
      if CleaningEntry.all_member_draw_done_check
        vacuum_id, wipe_id = CleaningEntry.draw_action
        DrawResult.result_record(vacuum_id, wipe_id)
        CleaningEntry.hit_count_add(vacuum_id, wipe_id) 
        mail_action
      end
    end   
  end
  
  def user_show
    user_id = params[:user][:user_id]
    pass = params[:user][:pass]
    @entry = CleaningEntry.find_by(user_id: user_id)
    if @entry == nil   
      flash.now[:notice] = "IDまたはパスワードが違います"
      render 'user_index' and return
    else
      @all_users_number, @already_entry_users_number = CleaningEntry.user_count
      if @entry.pass == pass
        session[:id] = @entry.id
        #既に抽選が完了していれば、抽選結果を表示させる
        if draw_result = DrawResult.find_by_id(1)
          if draw_result.draw_done_check
          @scrach_text_flag = 1
          @from_index_flag = 1
          @vacuum_cleaner_person, @wipe_person = CleaningEntry.result_check(draw_result.vacuum_id, draw_result.wipe_id)
          render "master_draw_result_sc" and return
          end
        end
        if @entry.join_flag == 1
          render 'user_already_result' and return
        end
      else
        flash.now[:notice] = "IDまたはパスワードが違います"
        render 'user_index' and return
      end
    end
  end
  
  #ログインしているユーザー用の情報編集画面
  def user_edit
    @user = CleaningEntry.find(session[:id])
  end
  
  def user_update
    user = CleaningEntry.find(session[:id])
    user.update(user_params)
    
    if user.errors.count == 0
      message = user.name+"さんのユーザー情報が更新されました"
    else
      message = user.errors.full_messages[0]
    end
    redirect_to draw_user_edit_path, notice: message
  end
  
  def master_top
  end
  
  def master_draw
    #登録されているユーザーに抽選番号を割り当てる
    CleaningEntry.draw_number_deal
    #抽選実行済み判断用フラグを下ろす
    DrawResult.result_flag_off
            
    render 'master_top'
  end

  def master_draw_result
    entries_arr = CleaningEntry.where(join_flag: 1)
    draw_result = DrawResult.find(1)
    
    if entries_arr.size <= 2
      @shortage_flag = 1
    else
      @shortage_flag = 0
      draw_result = DrawResult.where(id: 1)[0]
      if draw_result.result_flag == 0
        vacuum_id, wipe_id = CleaningEntry.draw_action
        DrawResult.result_record(vacuum_id, wipe_id)
        vacuum_id, wipe_id = DrawResult.duty_check
        CleaningEntry.hit_count_add(vacuum_id, wipe_id)
        mail_action
        @vacuum_cleaner_person, @wipe_person = CleaningEntry.result_check(vacuum_id, wipe_id)
      else
        vacuum_id, wipe_id = DrawResult.duty_check
        @vacuum_cleaner_person, @wipe_person = CleaningEntry.result_check(vacuum_id, wipe_id)
      end
    end
    
#    render 'master_draw_result'
    render 'master_draw_result_sc'
  end
  
  def logout
    session[:id] = nil
    
    redirect_to draw_user_index_path
  end
  
  #mailを送信する
  def mail_action
    ready_users = CleaningEntry.where(join_flag: 1)
    ready_users.each do |user|
      PostMailer.post_email(user.email).deliver
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :user_id, :pass, :email)
  end
  
  private
  def set_users_draw_info_get
    @users_draw_info = CleaningEntry.select("id, name, draw_no, join_flag, pass, join_count, hit_count, rate")
  end
end