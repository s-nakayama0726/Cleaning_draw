class PostMailer < ActionMailer::Base
  default from: "from@example.com"
  
  def post_email(address)
    draw_result = DrawResult.find(1)
    @vacuum_cleaner_person = CleaningEntry.find(draw_result.vacuum_id)
    @wipe_person = CleaningEntry.find(draw_result.wipe_id)
    mail(from: 'お掃除抽選結果',
         to: address)
  end
end
