#coding: utf-8

class DrawController < ApplicationController
  def user_index    
    #draw_entriesテーブルが空の場合、値を格納する
    draw_results = DrawResult.all
    if draw_results.empty?
      draw_result = DrawResult.new
      draw_result.id = 1
      draw_result.result_flag = 0
      draw_result.save
    end
    
    #既に抽選が完了していれば、トップページに抽選結果を表示させるためのフラグ用意（操作説明画面を抽選結果画面に変更）
    draw_result = DrawResult.find_by(id: 1)
    draw_flag = draw_result.result_flag
    if draw_flag == 1
      @from_index_flag = 1
      redirect_to draw_master_draw_result_path and return
    end
     
    #ログイン判断（session[:id]に値が入っているかどうか）
    #既にエントリーが済んでいるなら(join_flag==1なら）user_already_result画面に遷移、済んでいないならuser_show画面に遷移
    if session[:id] != nil
      @users_draw_info = CleaningEntry.select("id, name, draw_no, join_flag, pass")
      if CleaningEntry.find(session[:id]).join_flag == 1
        @entry = CleaningEntry.find(session[:id])
        render 'user_already_result' and return
      else
        render 'user_show'
      end
    end    
  end
  
  def user_result
    @entry = CleaningEntry.find(session[:id])
    @entry.join_flag = 1
    @entry.save
    @entry = CleaningEntry.find(session[:id])
    @users_draw_info = CleaningEntry.select("id, name, draw_no, join_flag, pass")
    
    #全員の抽選が確認できたらその時点で抽選実行を行う(3人以上登録されているとき)
    @ready_users = CleaningEntry.where("join_flag = '1'")
    @all_users = CleaningEntry.all
    if @all_users.size >= 3
      if @ready_users.size == @all_users.size
        #master_draw_resultアクションと同じ処理
        @entries_arr = @ready_users.map{|ready_user| [ready_user.id] }
        draw_result = DrawResult.find(1)
        vacuum_result_arr, wipe_result_arr = @entries_arr.sample(2)
        draw_result.vacuum_id = vacuum_result_arr[0]
        draw_result.wipe_id = wipe_result_arr[0]
        draw_result.result_flag = 1
        draw_result.save
        #mail
        @ready_users.each do |user|
          PostMailer.post_email(user.email).deliver
        end
      end
    end
  end
  
  def user_show
    @users_draw_info = CleaningEntry.select("id, name, draw_no, join_flag, pass")
    user_id = params[:user][:user_id]
    pass = params[:user][:pass]
    @entry = CleaningEntry.find_by(user_id: "#{user_id}")
    if @entry == nil   
      flash.now[:notice] = "IDまたはパスワードが違います"
      render 'user_index' and return
    else 
      if @entry.pass == pass
        session[:id] = @entry.id
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
    user.name = params[:user][:name]
    user.user_id = params[:user][:user_id]
    user.pass = params[:user][:pass]
    user.email = params[:user][:email]
    
    user.save
    if user.errors.count == 0
      message = user.name+"さんのユーザー情報が更新されました"
    else
      message = user.errors.full_messages[0]
    end
    redirect_to draw_user_edit_path, notice: message
  end
  
  def master_top
    #draw_entriesテーブルが空の場合、値を格納する
    draw_results = DrawResult.all
    if draw_results.empty?
      draw_result = DrawResult.new
      draw_result.id = 1
      draw_result.result_flag = 0
      draw_result.save
    end
  end
  
  def master_draw
    entries = CleaningEntry.all
    
    rand_num = (1..100).to_a.sample(entries.size)
    i=0  
    entries.each do |entry|
      entry.draw_no = rand_num[i]
      entry.join_flag = 0
      entry.save
      i = i + 1
    end
    
    draw_result_flag = DrawResult.find(1)
    draw_result_flag.result_flag = 0
    draw_result_flag.save
            
    render 'master_top'
  end

  def master_draw_result
    entries_arr = CleaningEntry.where("join_flag = '1'")
    draw_result = DrawResult.find(1)
    
    if entries_arr.size <= 2
      @shortage_flag = 1
    else
      @shortage_flag = 0
      if draw_result.result_flag == 0
        vacuum_result, wipe_result = entries_arr.sample(2)
        draw_result.vacuum_id = vacuum_result.id
        draw_result.wipe_id = wipe_result.id
        @vacuum_cleaner_person = CleaningEntry.find(vacuum_result.id)
        @wipe_person = CleaningEntry.find(wipe_result.id)
        draw_result.result_flag = 1
        draw_result.save
        #mail
        entries_arr.each do |entry|
          PostMailer.post_email(entry.email).deliver
        end
      else
        @vacuum_cleaner_person = CleaningEntry.find(draw_result.vacuum_id)
        @wipe_person = CleaningEntry.find(draw_result.wipe_id)
      end
    end
    
    render 'master_draw_result'
  end
  
  def logout
    session[:id] = nil
    
    redirect_to draw_user_index_path
  end
end