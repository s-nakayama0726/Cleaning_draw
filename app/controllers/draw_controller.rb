#coding: utf-8

class DrawController < ApplicationController
  def user_index
    @entry = CleaningEntry.all
  end
  
  def user_result
    entry = CleaningEntry.find(session[:id])
    entry.join_flag = 1
    entry.save
  end
  
  def user_show
    @entry = CleaningEntry.find(params[:entry][:id])
    session[:id] = @entry.id
    session[:name] = @entry.name
    session[:draw_no] = @entry.draw_no
    if @entry.join_flag >= 1
      render 'user_already_result'
    end
  end

  def user_params
    params.require(:entry).permit(:name, :id)
  end
  
  def master_top
  end
  
  def master_draw
      @entry = CleaningEntry.all
      @rand_num = (1..100).to_a.sort_by{rand}[1..@entry.size]
      
      @rand_num.size.times do |i|
        @entry[i].draw_no = @rand_num[i]
        @entry[i].join_flag = 0
        @entry[i].save
      end
      
      session[:vacuum_cleaner_person] = nil
      
      render 'master_top'
  end

  def master_draw_result
    @entry = CleaningEntry.all
    @entry_arr = @entry.map{ |entry| [entry.join_flag, entry.draw_no, entry.name] }
    
    i=0
    @entry_arr.delete_if {|item| 
      item[0] == 0
    }
    
    if session[:vacuum_cleaner_person] == nil
    
      @vacuum_cleaner_person,@wipe_person = @entry_arr.sample(2)
      session[:vacuum_cleaner_person] = @vacuum_cleaner_person
      session[:wipe_person] = @wipe_person
     
    else 
      
      @vacuum_cleaner_person = session[:vacuum_cleaner_person]
      @wipe_person = session[:wipe_person]
    
    end
    
    render 'master_draw_result'
  end
  
  private
  def user_params
     params.require(:user).permit(:name)
  end

end