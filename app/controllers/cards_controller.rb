class CardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @cards = current_user.cards.includes(:user, :group)
  end

  def new
    @card = current_user.cards.build
  end

  def create
    @card = current_user.cards.build(card_params)
    if @card.save
      respond_to do |format|
        # create.turbo_stream.erbをレンダリング
        format.turbo_stream
        format.html { redirect_to cards_path, notice: "カードが作成されました" }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # ストロングパラメータ
  def card_params
    params.require(:card).permit(:name, :memo)
  end
end
