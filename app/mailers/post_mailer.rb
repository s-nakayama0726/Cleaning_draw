class PostMailer < ActionMailer::Base
  
  def post_email(address)
    draw_result = DrawResult.find(1)
    @vacuum_cleaner_person = CleaningEntry.find(draw_result.vacuum_id)
    @wipe_person = CleaningEntry.find(draw_result.wipe_id)
    mail(from: 'お掃除抽選結果',
         to: address,
         subject: '本日のお掃除抽選結果')
  end
end
