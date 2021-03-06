class CleaningEntry < ActiveRecord::Base
  validates_uniqueness_of :user_id, :message => "既に登録されているユーザーIDです"
  validates :name, :presence => true
  validates :user_id, :presence => true
  validates :pass, :presence => true
  validates :email, :presence => true
  validates_format_of :user_id, with: /\A[a-z0-9]+\z/i, :message => "エラー　IDは半角英数字で登録してください"
  validates_format_of :pass, with: /\A[a-z0-9]+\z/i, :message => "エラー　パスワードは半角英数字で登録してください"
  validate :user_over_check
  
  before_save :encrypt_pass
  after_find :decrypt_pass
  
  #参加しているかどうかの判断用定数
  JOINED = 1
  scope :joined, ->{ where :join_flag => JOINED }
  
  def joined?
    self.join_flag == 1
  end
  
  #参加人数の総数と、現在エントリーが完了している人数を取得する
  def self.user_count
    all_users_number = CleaningEntry.all.size
    already_entry_users_number = CleaningEntry.where(join_flag: 1).size
    return all_users_number, already_entry_users_number
  end
  
  def user_over_check
    users = CleaningEntry.all
    if users.size >= 100
      errors.add(:id, "エラー　100人以上登録できません")
    end
  end
   
  #指定したidのユーザー情報を取得する
  def self.result_check(vacuum_id, wipe_id)
    return CleaningEntry.find_by_id(vacuum_id), CleaningEntry.find_by_id(wipe_id)
  end
   
  
  #テーブルに登録されている全てのユーザーのエントリーが完了したかどうかを確認する
  def self.all_member_draw_done_check
    CleaningEntry.select(:id, :pass, :join_flag).all?(&:joined?)
  end
   
  def self.draw_action
    ready_users = CleaningEntry.select(:id, :pass, :join_count, :hit_count, :draw_no).joined
    draw_result_arr = ready_users.sample(2)
    
    return CleaningEntry.find_by("draw_no = ?" ,ready_users.maximum(:draw_no)).id, CleaningEntry.find_by("draw_no = ?" ,ready_users.minimum(:draw_no)).id
  end
   
  #登録されているユーザーに抽選番号を割り当てる
  def self.draw_number_deal
    entries = CleaningEntry.all
     
    rand_num = (1..100).to_a.sample(entries.size)
    i=0  
    entries.each do |entry|
      entry.update(draw_no: rand_num[i], join_flag: 0)
      i = i + 1
    end
  end
  
  def draw_number_deal_for_create
    #既に割り当てられたナンバー以外の抽選ナンバーを割り当て
    users = CleaningEntry.where("draw_no not ?", nil)
    users_draw_no = users.map{|user| user.draw_no}
    rand_num_arr = (1..100).to_a
    rand_num_arr = rand_num_arr - users_draw_no
    self.draw_no = rand_num_arr.sample
  end
  
  def hit_rate_get
    return self.rate = 0 if self.join_count == 0 if self.hit_count == 0
    self.rate = self.hit_count.to_f / self.join_count.to_f * 100
  end
  
  def join_count_add
    self.join_count = self.join_count + 1
  end
  
  def self.hit_count_add(vacuum_id, wipe_id)
    vacuum_person = CleaningEntry.find_by_id(vacuum_id)
    wipe_person = CleaningEntry.find_by_id(wipe_id)
    vacuum_person.hit_count = vacuum_person.hit_count + 1
    vacuum_person.save
    wipe_person.hit_count = wipe_person.hit_count + 1
    wipe_person.save
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
