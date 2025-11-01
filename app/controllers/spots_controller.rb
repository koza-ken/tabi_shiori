class SpotsController < ApplicationController
  before_action :set_card, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :set_spot, only: [ :show, :edit, :update, :destroy ]
  before_action :check_show_spot, only: [ :show, :new, :create, :edit, :update, :destroy ]

  def show
  end

  def new
    @spot = @card.spots.build
    @categories = Category.all.order(:display_order)
  end

  def create
    @spot = @card.spots.build(spot_params)
    if @spot.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to card_path(@card), notice: t("notices.spots.created") }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.all.order(:display_order)
  end

  def update
    if @spot.update(spot_params)
      # TODO 更新成功のフラッシュメッセージが正しく表示されない
      redirect_to card_spot_path(@card, @spot), notice: t("notices.spots.updated")
    else
      render :edit, status: :unprocessable_entity, alert: "更新に失敗しました"
    end
  end

  def destroy
    @spot.destroy!
    redirect_to card_path(@card), notice: t("notices.spots.destroyed")
  end

  private

  def spot_params
    params.require(:spot).permit(:name, :address, :phone_number, :website_url, :category_id)
  end

  def set_card
    @card = Card.find(params[:card_id])
  end

  def set_spot
    @spot = Spot.find(params[:id])
  end

  def check_show_spot
    # new、createアクションは@card、showアクションは@spotからcardを取得
    @card ||= @spot&.card
    # group_idがある（個人カードじゃない）ときはグループ詳細に飛ばす
    if @card.group_id.present?
      redirect_to (user_signed_in? ? group_path(@card.group) : root_path), alert: t("errors.spots.unauthorized_view")
      return
    end
    # ログインしていない場合 → new_user_session_path へ
    unless user_signed_in?
      redirect_to new_user_session_path, alert: t("errors.spots.unauthorized_view")
      return
    end
    # カードの所有者確認
    unless @card.user_id == current_user.id
      redirect_to cards_path, alert: t("errors.spots.unauthorized_view")
    end
  end
end
