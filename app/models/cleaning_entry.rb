class CleaningEntry < ActiveRecord::Base
   validates_uniqueness_of :user_id, :message => "既に登録されているユーザーIDです"
   validates :name, :presence => true
   validates :user_id, :presence => true
   validates :pass, :presence => true
   validates :email, :presence => true
   validates_format_of :user_id, with: /\A[a-z0-9]+\z/i, :message => "エラー　IDは半角英数字で登録してください"
   validates_format_of :pass, with: /\A[a-z0-9]+\z/i, :message => "エラー　パスワードは半角英数字で登録してください"
   
   before_save :encrypt_pass
   after_find :decrypt_pass
   
   #指定したidのユーザー情報を取得する
   def self.result_check(vacuum_id, wipe_id)
      return CleaningEntry.find_by_id(vacuum_id), CleaningEntry.find_by_id(wipe_id)
   end
   
   #テーブルに登録されている全てのユーザーのエントリーが確認できた場合、抽選を行う
   def self.all_member_draw_done_check
     ready_users = CleaningEntry.where("join_flag = '1'")
     all_users = CleaningEntry.all
     all_users.size >= 3 if ready_users.size == all_users.size
   end
   
   def self.draw_action
    ready_users = CleaningEntry.where("join_flag = '1'")
    entries_arr = ready_users.map{|ready_user| [ready_user.id]}
    entries_arr.sample(2)
    ready_users.each do |user|
      PostMailer.post_email(user.email).deliver
    end
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
