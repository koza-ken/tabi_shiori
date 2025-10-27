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
    @card = Card.find(params[:id])
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
  def check_create_cards
    group_id = card_params[:group_id]

    # ログインしていない場合（ログインしていたら個人カード作成）
    unless user_signed_in?
      # ログインしていなくて、グループ所属もない場合のカード作成は、URL直接入力なので拒否
      if group_id.blank?
        @card = Card.new
        @card.errors.add(:base, "カードを作成するにはログインするかグループに参加してください１")
        render :new, status: :unprocessable_entity
        return
      end

      # ゲストトークンをcookieから取得
      guest_tokens = cookies.encrypted[:guest_tokens] ? JSON.parse(cookies.encrypted[:guest_tokens]) : {}
      stored_token = guest_tokens[group_id.to_s]

      # ログインしていなくて、tokenがないか、tokenが一致しない場合は権限なし
      if stored_token.blank? || !GroupMembership.exists?(group_id: group_id, guest_token: stored_token)
        @card = Card.new
        @card.errors.add(:base, "カードを作成するにはログインするかグループに参加してください２")
        render :new, status: :unprocessable_entity
      end
    end
  end

  # カード詳細にアクセスできるのは、自分の個人用カードか、参加しているグループのカード
  def check_show_card
    @card = Card.find(params[:id])
    # ログインしている
    if user_signed_in?
      # グループのカードじゃない
      if @card.group_id.nil?
        if current_user.id != @card.user_id
          redirect_to cards_path, alert: "他人のカードは見ることができません"
        end
      else
        unless GroupMembership.exists?(user_id: current_user.id, group_id: @card.group_id)
          redirect_to groups_path, alert: "このグループに参加していません"
        end
      end
    # ログインしていない
    else
      # ゲストユーザーの場合
      if @card.group_id.present?
        # グループカード：ゲストも所属しているグループのみアクセス可能
        guest_tokens = cookies.encrypted[:guest_tokens] ? JSON.parse(cookies.encrypted[:guest_tokens]) : {}
        guest_group_ids = guest_tokens.keys.map(&:to_i)

        unless guest_group_ids.include?(@card.group_id)
          redirect_to root_path, alert: "このカードを閲覧する権限がありません"
        end
      else
        # ゲストは個人カードにアクセスできない
        redirect_to root_path, alert: "このカードを閲覧する権限がありません"
      end
    end
  end
end
