#coding: utf-8

class DrawController < ApplicationController
  def user_index
  end
  
  def user_result
    entry = CleaningEntry.find(session[:id])
    entry.join_flag = 1
    entry.save

  end
  
  def user_show
    @users_draw_info = CleaningEntry.select("name,draw_no,join_flag,pass")
    user_id = params[:user][:user_id]
    pass = params[:user][:pass]
    entry = CleaningEntry.find_by(user_id: "#{user_id}")
    if entry == nil   
      flash.now[:notice] = "IDまたはパスワードが違います"
      render 'user_index' and return
    else 
      if entry.pass == pass
        session[:id] = entry.id
        session[:name] = entry.name
        session[:draw_no] = entry.draw_no
        if entry.join_flag >= 1
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
      
    session[:vacuum_cleaner_person] = nil
      
    render 'master_top'
  end

  def master_draw_result
    entries = CleaningEntry.all
    @entries_arr = entries.map{ |entry| [entry.join_flag, entry.draw_no, entry.name] }
    
    i=0
    @entries_arr.delete_if {|item| 
      item[0] == 0
    }
    
    if session[:vacuum_cleaner_person] == nil
      @vacuum_cleaner_person,@wipe_person = entries_arr.sample(2)
      session[:vacuum_cleaner_person] = @vacuum_cleaner_person
      session[:wipe_person] = @wipe_person     
    else
      @vacuum_cleaner_person = session[:vacuum_cleaner_person]
      @wipe_person = session[:wipe_person] 
    end
    
    render 'master_draw_result'
  end
end