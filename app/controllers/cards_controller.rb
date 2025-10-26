class CardsController < ApplicationController
  before_action :authenticate_user!, except: [ :new, :create ]
  # ゲストユーザーでもグループ内でカード作成ができるように
  before_action :authorize_group_member, only: [ :create ]

  def index
    @cards = current_user.cards.includes(:user, :group)
  end

  def new
    # group_idはJavaScriptで設定されるので、空のカードを作成
    @card = Card.new
  end

  def create
    @card = build_card

    if @card.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to redirect_path, notice: "カードが作成されました" }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # カードを作成（group_idの有無で分岐）
  def build_card
    if card_params[:group_id].present?
      # グループのカードを作成（user_idはnil）
      Card.new(card_params)
    else
      # ユーザーのカードを作成（group_idはnil）
      current_user.cards.build(card_params)
    end
  end

  # リダイレクト先を決定
  def redirect_path
    @card.group_id.present? ? group_path(@card.group_id) : cards_path
  end

  # ストロングパラメータ
  def card_params
    params.require(:card).permit(:name, :memo, :group_id)
  end

  # refa
  # ゲストがグループ内でカードを作成できるようにするフィルター
  def authorize_group_member
    group_id = card_params[:group_id]
    if user_signed_in?
      unless GroupMembership.exists?(user_id: current_user.id, group_id: group_id)
        redirect_to groups_path, alert: "このグループに参加していません"
      end
    else
      # cookieにゲストトークンが保存されていればcookieからトークンを含むハッシュをguest_tokensに返し、保存されていなければ空のハッシュを返す
      guest_tokens = cookies.encrypted[:guest_tokens] ? JSON.parse(cookies.encrypted[:guest_tokens]) : {}
      # トークンがあればハッシュからトークンの値を取り出す（グループに参加していない場合はnilになる）
      stored_token = guest_tokens[group_id.to_s]
      if stored_token.nil?
        redirect_to root_path, alert: "このグループに参加していません"
        return
      end
      unless GroupMembership.exists?(group_id: group_id, guest_token: stored_token)
        redirect_to root_path, alert: "このグループに参加していません"
      end
    end
  end
end
