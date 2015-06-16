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
    if @entry.join_flag == 1
      render 'user_already_result'
    end
  end


  
  def user_params
    params.require(:entry).permit(:name, :id)
  end
end