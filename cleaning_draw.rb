#抽選番号の取得
str = gets
str_array = str.split(/\s/);

#抽選をする各人の抽選ナンバーを格納するハッシュを作成
person_hash = Hash.new
for key in str_array
  person_hash["#{key}"] = ""
end

#全てのキーを配列として取得
array = person_hash.keys

#抽選ナンバーをランダムに２つ取得
#１つ目のナンバーが”掃除機当番”、２つ目のナンバーが”拭き掃除当番”
vacuum_cleaner_person = array.sample
wipe_person = array.sample
#掃除機当番と被らない番号が出るまで抽選
until vacuum_cleaner_person != wipe_person
  wipe_person = array.sample
end 

#表示
print "掃除機当番は",vacuum_cleaner_person,"番さんです\n"
print "拭き掃除当番は",wipe_person,"番さんです\n"
print "他の人はごみ収集とごみ捨てをお願いします\n"
print "頑張りましょう\n"


