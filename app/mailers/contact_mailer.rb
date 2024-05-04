class ContactMailer < ApplicationMailer
  def send_mail(contact, user)
    @contact = contact
    @user = user
    @contact.email = @user.email
    mail to:   ENV['GOOGLE_SMTP_EMAIL'], subject: '【お問い合わせ】' + @contact.subject
  end
end
