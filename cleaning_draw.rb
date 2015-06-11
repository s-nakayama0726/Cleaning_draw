#エンコードの型をutf-8に指定。日本語を読み込める。
Encoding.default_external = "utf-8"

#抽選ナンバーと名前の取得
#str_arrayクラスは二次元配列。各要素の二つ目の要素は0番目が抽選ナンバー、1番目が名前
str_array=[]
i=0
while str = gets
  str = str.chomp
  str_array[i] = str.split(/,/)
  i=i+1
end

#重複チェックのための抽選ナンバー取得
j=0
check_num=[]
while j<str_array.size
  check_num[j] = str_array[j][0]
  j=j+1
end

#重複チェック。falseなら45行目のelseへジャンプ
if check_num.size == check_num.uniq.size then
  #抽選をする各人の抽選ナンバーと名前を格納するハッシュを作成
  #抽選ナンバーがキー、名前が内容
  person_hash = Hash.new
  target = 0
  while target < str_array.size
    key = str_array[target][0]
    person_hash["#{key}"] = str_array[target][1]
    target = target + 1
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
  puts "掃除機当番は"+person_hash["#{vacuum_cleaner_person}"]+"さんです"
  puts "拭き掃除当番は"+person_hash["#{wipe_person}"]+"さんです"
  puts "他の人はごみ収集とごみ捨てをお願いします"
  puts "頑張りましょう\n"

else
  puts "重複した番号があります。番号は重複しないように入力して下さい"
end