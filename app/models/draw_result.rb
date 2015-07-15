class DrawResult < ActiveRecord::Base
  
  #抽選が完了しているかをチェック
  def draw_done_check
    self.result_flag == 1  
  end
  
  def self.result_record(vacuum_result_id, wipe_result_id)
    draw_result = DrawResult.find(1)
    draw_result.vacuum_id = vacuum_result_id
    draw_result.wipe_id = wipe_result_id
    DrawResult.result_flag_on
  end
  
  #現在の当番idをチェック
  def self.duty_check
    draw_result = DrawResult.find(1)
    return draw_result.vacuum_id, draw_result.wipe_id
  end
  
  #抽選実行済み判断用フラグを下ろす
  def self.result_flag_off
    draw_result_flag = DrawResult.find(1)
    draw_result_flag.result_flag = 0
    draw_result_flag.save
  end
  
  #抽選実行済み判断用フラグを上げる
  def self.result_flag_on
    draw_result_flag = DrawResult.find(1)
    draw_result_flag.result_flag = 1
    draw_result_flag.save
  end
end
