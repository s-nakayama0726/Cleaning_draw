#エンコードの型をutf-8に指定。日本語を読み込める。
Encoding.default_external = "utf-8"

#抽選ナンバーと名前の取得
#person_hashはキーとして抽選ナンバー、値として名前を持つハッシュ
person_hash = Hash.new
i = 0
while person_data_line = gets
  person_data_line = person_data_line.chomp
  key,person_hash[key] = person_data_line.split(/,/)
  i = i + 1
end

#抽選
vacuum_cleaner_person,wipe_person = person_hash.keys.sample(2)

#表示
puts "掃除機当番は抽選ナンバー"+vacuum_cleaner_person+"の"+person_hash[vacuum_cleaner_person]+"さんです"
puts "拭き掃除当番は抽選ナンバー"+wipe_person+"の"+person_hash[wipe_person]+"さんです"
puts "他の人はごみ収集とごみ捨てをお願いします"
puts "頑張りましょう\n"
