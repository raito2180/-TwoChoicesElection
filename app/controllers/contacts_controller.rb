class ContactsController < ApplicationController
  before_action :redirect_root
  
  def new
    @contact = Contact.new
  end

  def create
    @contact = current_user.contacts.new(contact_params)
    binding.pry
    if @contact.save
      ContactMailer.send_mail(@contact, current_user).deliver_now
      redirect_to done_path, flash: { success: 'お問い合わせが完了しました' }
    else
      flash.now[:danger] = '作成失敗'
      render :new, status: :unprocessable_entity
    end
  end

  # 送信完了画面を使用する場合お使いください。
  def done
  end

  private

  def contact_params
    params.require(:contact).permit(:name,:subject,:body)
  end
end
