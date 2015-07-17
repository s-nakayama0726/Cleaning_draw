class CleaningEntry < ActiveRecord::Base
  validates_uniqueness_of :user_id, :message => "既に登録されているユーザーIDです"
  validates :name, :presence => true
  validates :user_id, :presence => true
  validates :pass, :presence => true
  validates :email, :presence => true
  validates_format_of :user_id, with: /\A[a-z0-9]+\z/i, :message => "エラー　IDは半角英数字で登録してください"
  validates_format_of :pass, with: /\A[a-z0-9]+\z/i, :message => "エラー　パスワードは半角英数字で登録してください"
  validate :user_over_check
   
  before_save :draw_no_deal, :encrypt_pass
  after_find :decrypt_pass
  
  #参加しているかどうかの判断用定数
  JOINED = 1
  scope :joined, ->{ where :join_flag => JOINED }
  
   
  def user_over_check
    users = CleaningEntry.all
    if users.size >= 100
      errors.add(:id, "エラー　100人以上登録できません")
    end
  end
   
  def draw_no_deal
    #既に割り当てられたナンバー以外の抽選ナンバーを割り当て
    users = CleaningEntry.all
    rand_num_arr = (1..100).to_a
    rand_num_arr.reject! do |num|
      search_result = CleaningEntry.where("draw_no = '#{num}'")
      search_result.size >= 1
    end
    self.draw_no = rand_num_arr.sample
  end
   
  #指定したidのユーザー情報を取得する
  def self.result_check(vacuum_id, wipe_id)
    return CleaningEntry.find_by_id(vacuum_id), CleaningEntry.find_by_id(wipe_id)
  end
   
  #テーブルに登録されている全てのユーザーのエントリーが確認できた場合、抽選を行う
  def self.all_member_draw_done_check
    ready_users = CleaningEntry.select(:id, :pass).joined
    all_users = CleaningEntry.all
    all_users.size >= 3 if ready_users.size == all_users.size
  end
   
  def self.draw_action
    ready_users = CleaningEntry.select(:id, :pass).joined
    draw_result_arr = ready_users.sample(2)
    return draw_result_arr[0].id, draw_result_arr[1].id
  end
   
  #登録されているユーザーに抽選番号を割り当てる
  def self.draw_number_deal
    entries = CleaningEntry.all
     
    rand_num = (1..100).to_a.sample(entries.size)
    i=0  
    entries.each do |entry|
      entry.draw_no = rand_num[i]
      entry.join_flag = 0
      entry.save
      i = i + 1
    end
  end
   
  def encrypt_pass
    self.pass = encrypt(self.pass)
  end
   
  def decrypt_pass
    self.pass = decrypt(self.pass)
  end
   
  SECURE = 'CLEANINGDRAWPASSWORDCLEANINGDRAWPASSWORDCLEANINGDRAWPASSWORD'
  CIPHER = 'aes-256-cbc'

  def encrypt(password)
    crypt = ActiveSupport::MessageEncryptor.new(SECURE, CIPHER)
    crypt.encrypt_and_sign(password)
  end
   
  def decrypt(pass)
    crypt = ActiveSupport::MessageEncryptor.new(SECURE, CIPHER)
    crypt.decrypt_and_verify(pass)
  end
end
