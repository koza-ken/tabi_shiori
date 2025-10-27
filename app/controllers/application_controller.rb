class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # フレンドリーフォアーディング
  before_action :store_user_location!, if: :storable_location?

  # concernに書いたモジュールをinclude
  include GuestAuthentication

  # ログイン後のリダイレクト先を設定（resouceを渡すとユーザーの属性で判別できる）
  # def after_sign_in_path_for(resource)
  #   store_location_for(:user, request.fullpath) || cards_path
  # end

  private

  # フレンドリーフォアーディング
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end
  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
end
