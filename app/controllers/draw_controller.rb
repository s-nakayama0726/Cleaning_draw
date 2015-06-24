#coding: utf-8

class DrawController < ApplicationController
  def user_index
    if session[:id] != nil
      @users_draw_info = CleaningEntry.select("name,draw_no,join_flag,pass")
      @entry = CleaningEntry.find(session[:id])
      render 'user_already_result' and return
    end
  end
  
  def user_result
    entry = CleaningEntry.find(session[:id])
    entry.join_flag = 1
    entry.save
    @users_draw_info = CleaningEntry.select("id,name,draw_no,join_flag,pass")
  end
  
  def user_show
    @users_draw_info = CleaningEntry.select("name,draw_no,join_flag,pass")
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

  def master_top
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
    entries = CleaningEntry.where("join_flag = '1'")
    draw_result = DrawResult.find(1)
    #master_draw_result画面において、抽選に必要な最低限の人数が参加しているか判断をするためにインスタンス変数
    @entries_arr = entries.map{|entry| [entry.id] }
    
    if draw_result.result_flag == 0
      vacuum_result_arr, wipe_result_arr = @entries_arr.sample(2)
      draw_result.vacuum_id = vacuum_result_arr[0]
      draw_result.wipe_id = wipe_result_arr[0]
      @vacuum_cleaner_person = CleaningEntry.find(vacuum_result_arr[0])
      @wipe_person = CleaningEntry.find(wipe_result_arr[0])
      draw_result.result_flag = 1
      draw_result.save
    else
      @vacuum_cleaner_person = CleaningEntry.find(draw_result.vacuum_id)
      @wipe_person = CleaningEntry.find(draw_result.wipe_id)
    end
    
    render 'master_draw_result'
  end
  
  def logout
    session[:id] = nil
    
    redirect_to draw_user_index_path
  end
end