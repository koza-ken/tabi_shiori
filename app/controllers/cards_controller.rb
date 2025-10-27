class CardsController < ApplicationController
  before_action :authenticate_user!, except: [ :new, :create ]
  # ゲストユーザーでもグループ内でカード作成ができるように
  before_action :check_create_cards, only: [ :create ]
  # 自分のカードか、参加しているグループのカードのみにアクセスできる
  before_action :check_show_card, only: [ :show ]

  def index
    @cards = current_user.cards.includes(:user, :group)
  end

  def show
  end

  def new
    # group_idはJavaScriptで設定されるので、空のカードを作成
    @card = Card.new
  end

  def create
    @card = Card.build_for(user: current_user_if_signed_in, attributes: card_params)

    if @card.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to redirect_path_for(@card), notice: "カードが作成されました" }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_card
    @card = Card.find(params[:id])
  end

  # ログインしていればcurrent_user、していなければnilを返す（ログインの有無の条件分岐が不要になる）
  def current_user_if_signed_in
    user_signed_in? ? current_user : nil
  end

  # リダイレクト先を決定
  def redirect_path_for(card)
    card.group_card? ? group_path(card.group_id) : cards_path
  end

  # ストロングパラメータ
  def card_params
    params.require(:card).permit(:name, :memo, :group_id)
  end

  # refa
  # ゲストがグループ内でカードを作成できるようにするフィルター
  def check_create_cards
    group_id = card_params[:group_id]

    # ログインしていない場合（ログインしていたら個人カード作成）
    unless user_signed_in?
      # ログインしていなくて、グループ所属もない場合のカード作成は、URL直接入力なので拒否
      if group_id.blank?
        render_guest_creation_error("カードを作成するにはログインするかグループに参加してください１")
        return
      end

      # ゲストトークンをcookieから取得（concernのモジュール）
      stored_token = guest_token_for(group_id)

      # ログインしていなくて、tokenがないか、tokenが一致しない場合は権限なし
      unless GroupMembership.guest_member?(stored_token, group_id)
        render_guest_creation_error("カードを作成するにはログインするかグループに参加してください２")
      end
    end
  end

  # カード詳細にアクセスできるのは、自分の個人用カードか、参加しているグループのカード
  def check_show_card
    authorized = @card.accessible?(user: current_user_if_signed_in, guest_group_ids: guest_group_ids)

    unless authorized
      redirect_to (user_signed_in? ? cards_path : root_path),
                  alert: "このカードを閲覧する権限がありません"
    end
  end

  # ゲストがカードの作成に失敗したときのレンダリング処理
  def render_guest_creation_error(message)
    @card = Card.new
    @card.errors.add(:base, message)
    render :new, status: :unprocessable_entity
  end
end
