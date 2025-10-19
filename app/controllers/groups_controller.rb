class GroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @groups = current_user.created_groups.includes(:group_memberships)
  end

  def new
    @form = GroupCreateForm.new
  end

  def create
    # フォームのデータにcurrent_userを追加することで、フォームオブジェクトで扱える（@form.userで参照できる）
    @form = GroupCreateForm.new(group_form_params.merge(user: current_user))
    # モデルにコールバックを設定してトークン生成
    if @form.save
      redirect_to groups_path, notice: "グループが作成されました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # ストロングパラメータ
  def group_form_params
    params.require(:group_create_form).permit(:name, :trip_name, :start_date, :end_date, :group_nickname)
  end
end
