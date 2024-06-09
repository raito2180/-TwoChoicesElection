class ApplicationController < ActionController::Base
  before_action :set_profile
  before_action :ensure_profile
  before_action :set_user_id_to_cookie

  def self.render_with_signed_in_user(user, *args)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap{|i| i.set_user(user, scope: :user) }
    renderer = self.renderer.new('warden' => proxy)
    renderer.render(*args)
  end

  private
  
  def redirect_root
    redirect_to root_path, flash: { success: 'ログインしてください' } unless user_signed_in?
  end

  def set_profile
    if user_signed_in?
      @profile = current_user.profile
      cookies.signed["user.id"] = current_user.id
    end
  end

  def ensure_profile
    if user_signed_in? && current_user.profile.nil?
      Profile.create(user: current_user, name: "ファン#{current_user.id}号", gender: 0, body: 'こんにちは、皆でフットサルやりましょう!')
    end
  end

  def set_user_id_to_cookie
    if current_user
      cookies.signed["user.id"] = current_user.id
    end
  end

end
