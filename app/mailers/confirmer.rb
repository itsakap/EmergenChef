class Confirmer < ActionMailer::Base
  default from: "from@example.com"
  def welcome(recipient_id)
    @account = User.find(recipient_id)
    mail(to: @account.email_address, subject: "Welcome!")
  end

  def emergency(order_id, user_id)
    @ord = Order.find(order_id)
    @account = User.find(user_id)
    
    mail(to: "emergenchef@gmail.com", subject: "Emergency for #{@account.username}")
  end
end
