class ContactMailer < ApplicationMailer
  def send_mail(contact, user)
    @contact = contact
    @user = user
    @contact.email = @user.email
    mail to: ENV.fetch('GOOGLE_SMTP_EMAIL', nil), subject: "【お問い合わせ】#{@contact.subject}"
  end
end
