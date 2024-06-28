class ApplicationController < ActionController::Base
  before_action :set_profile, if: :user_signed_in?
  before_action :ensure_profile
  before_action :set_user_id_to_cookie

  def self.render_with_signed_in_user(user, *)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap { |i| i.set_user(user, scope: :user) }
    renderer = self.renderer.new('warden' => proxy)
    renderer.render(*)
  end

  def mobile_device?
    request.user_agent =~ /Mobile|webOS/
  end

  private

  def redirect_root
    redirect_to root_path, flash: { notice: 'ログインしてください' } unless user_signed_in?
  end

  def set_profile
    @profile = current_user.profile
    cookies.signed["user.id"] = current_user.id
  end

  def ensure_profile
    Profile.create(user: current_user, name: "ファン#{current_user.id}号", gender: 0, body: 'こんにちは、皆でフットサルやりましょう!') if user_signed_in? && current_user.profile.nil?
  end

  def set_user_id_to_cookie
    cookies.signed["user.id"] = current_user.id if current_user
  end
end
