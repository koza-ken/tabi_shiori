class GroupsController < ApplicationController
  before_action :authenticate_user!, except: :join

  def index
    @groups = current_user.created_groups.includes(:group_memberships)
  end

  def show
    @group = Group.includes(:group_memberships, :cards).find(params[:id])
  end

  def new
    @form = GroupCreateForm.new
  end

  def create
    # フォームのデータにcurrent_userを追加することで、フォームオブジェクトで扱える（@form.userで参照できる）
    @form = GroupCreateForm.new(group_form_params.merge(user: current_user))
    # モデルにコールバックを設定してトークン生成
    if @form.save
      @group = @form.group  # フォームオブジェクトから作成されたグループを取得
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to groups_path, notice: "グループが作成されました" }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # グループ招待時の参加機能
  def join
    @group = Group.find_by(invite_token: params[:invite_token])
    # トークンが既存グループと一致するか
    if @group.nil?
      redirect_to root_path, notice: "無効なリンクです"
      return
    end
    # ユーザーがログインしているか
    unless user_signed_in?
      store_user_location!
      redirect_to new_user_session_path
      return
    end
    # グループメンバーシップのレコード作成（グループに参加紐づけ）
    if @group.group_memberships.exists?(user_id: current_user.id)
      redirect_to group_path(@group.id), notice: "#{@group.name}には参加済みです", status: :see_other
    else
      @group.group_memberships.create(user_id: current_user.id, group_nickname: current_user.email, role: "member")
      redirect_to group_path(@group.id), notice: "#{@group.name}に参加しました", status: :see_other
    end
  end

  private

  # ストロングパラメータ
  def group_form_params
    params.require(:group_create_form).permit(:name, :trip_name, :start_date, :end_date, :group_nickname)
  end
end
