class Confirmer < ActionMailer::Base
  default from: "from@example.com"
  def welcome(recipient)
    @account = recipient
    mail(to: recipient[:email_address], subject: "Welcome!")
  end
end
