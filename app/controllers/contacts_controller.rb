class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = current_user.contacts.new(contact_params)
    binding.pry
    if @contact.save
      ContactMailer.send_mail(@contact, current_user).deliver_now
      redirect_to done_path, success: '作成成功'
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
