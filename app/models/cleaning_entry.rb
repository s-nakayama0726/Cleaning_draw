class CleaningEntry < ActiveRecord::Base
   validates_uniqueness_of :user_id, :message => "既に登録されているユーザーIDです"
   validates_format_of :user_id, with: /\A[a-z0-9]+\z/i, :message => "エラー　ID及びパスワードは半角英数字で登録してください"
   validates_format_of :pass, with: /\A[a-z0-9]+\z/i, :message => "エラー　ID及びパスワードは半角英数字で登録してください"
   
   before_save :encrypt_pass
   after_find :decrypt_pass

   
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
