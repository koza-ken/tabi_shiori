class CardsController < ApplicationController
  before_action :authenticate_user!

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
end
