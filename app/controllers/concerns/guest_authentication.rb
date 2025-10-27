# Cookie に保存されたゲストユーザーの「どのグループに参加しているか」と「各グループの認証トークン」を取得するメソッド、書き込みのメソッド
module GuestAuthentication
  extend ActiveSupport::Concern

  # cookieから全ゲストトークンを取得
  def guest_tokens
    return {} if cookies.encrypted[:guest_tokens].blank?
    JSON.parse(cookies.encrypted[:guest_tokens])
  rescue JSON::ParserError
    {}
  end

  # ゲストが参加している全グループIDを取得
  def guest_group_ids
    guest_tokens.keys.map(&:to_i)
  end

  # 特定グループのゲストトークンを取得
  def guest_token_for(group_id)
    guest_tokens[group_id.to_s]
  end

  # 書き込みメソッド
  def set_guest_token(group_id, token)
    tokens = guest_tokens
    tokens[group_id.to_s] = token
    cookies.encrypted[:guest_tokens] = tokens.to_json
  end
end
