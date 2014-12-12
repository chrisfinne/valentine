class PoemMailer < ActionMailer::Base
  default from: "from@example.com"

  def send_poem poem
    @poem = poem
    mail to: poem.to_email, subject: "Be my Valentine"
  end
end
