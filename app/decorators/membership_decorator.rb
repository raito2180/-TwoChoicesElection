class MembershipDecorator < Draper::Decorator
  delegate_all

  def create_notice_message
    case object.status
    when '参加'
      '参加しました。'
    when '不参加'
      '不参加で入力しました。'
    else
      '興味ありで入力しました。'
    end
  end

  def update_notice_message
    case object.status
    when '参加'
      '参加に変更しました。'
    when '不参加'
      '不参加に変更しました。'
    else
      '興味ありに変更しました。'
    end
  end
end
