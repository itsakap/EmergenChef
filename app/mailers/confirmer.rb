class Confirmer < ActionMailer::Base
  default from: "from@example.com"
  def welcome(recipient_id)
    @account = User.find(recipient_id)
    mail(to: @account.email_address, subject: "Welcome!")
  end
end
