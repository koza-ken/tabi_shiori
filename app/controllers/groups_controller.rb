class GroupsController < ApplicationController
  before_action :authenticate_user!, except: [ :show, :new_membership, :create_membership ]

  def index
    @groups = current_user.groups.includes(:group_memberships)
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

  # refa
  # グループ招待ページ
  def new_membership
    @group = Group.find_by(invite_token: params[:invite_token])
    # トークンが既存グループと一致するか
    if @group.nil?
      redirect_to root_path, notice: "無効なリンクです"
      return
    end

    # ユーザーがログインしているかで、グループ詳細ページか、招待ページを表示
    if user_signed_in? && @group.group_memberships.exists?(user_id: current_user.id)
      # グループにユーザーのメンバーシップがあればグループ詳細ページに遷移
      redirect_to group_path(@group.id)
    else
      # ニックネームの一覧を取得
      @member_nicknames = @group.group_memberships.where(user_id: nil).pluck(:group_nickname)
      # メンバーシップがなければ、招待ページを表示
      render :new_membership
    end
  end

  # refa
  # グループ参加ページからのデータ処理
  def create_membership
    @group = Group.find_by(invite_token: params[:invite_token])

    if @group.nil?
      redirect_to root_path, notice: "無効なリンクです"
      return
    end

    case params[:membership_source]
    when "dropdown"
      # 選択したニックネームからメンバーシップを取得
      @group_membership = @group.group_memberships.find_by(group_nickname: params[:group_nickname])
      if @group_membership.nil?
        # 見つからない場合のエラー処理
        redirect_to new_membership_path(@group.invite_token), alert: "選択したユーザーが見つかりません"
        return
      end

      # ログイン状態の確認
      if user_signed_in?
        # 取得したメンバーシップにuser_idを追加
        @group_membership.update(user_id: current_user.id)
      else
        # ゲストユーザーの場合は、トークンがcookieに残っているか確認
        if @group_membership.guest_token.blank?
          # ゲストでcookieのトークンが残っていない場合は、トークンをメンバーシップのテーブルに保存
          @group_membership.update(guest_token: @group_membership.generate_guest_token)
          # cookieのハッシュを取得（JSON文字列からパース）
          guest_tokens = cookies.encrypted[:guest_tokens] ? JSON.parse(cookies.encrypted[:guest_tokens]) : {}
          # ハッシュに保存 → { "1" => "abc123..." }
          guest_tokens[@group.id.to_s] = @group_membership.guest_token
          # JSON文字列に変換してcookieに保存
          cookies.encrypted[:guest_tokens] = guest_tokens.to_json
        end
      end

      # ゲストの場合、Cookie のトークンと一致確認
      if @group_membership.user_id.nil?
        # cookieのguest_tokenのハッシュを取得（JSON文字列からパース）
        guest_tokens = cookies.encrypted[:guest_tokens] ? JSON.parse(cookies.encrypted[:guest_tokens]) : {}
        stored_token = guest_tokens[@group.id.to_s]

        # cokkieに記録してあるトークンとテーブルに保存してあるゲストユーザーのトークンが一致していない場合
        if stored_token != @group_membership.guest_token
          redirect_to new_membership_path(@group.invite_token), alert: "トークンが一致しません"
          return
        end
      end

      redirect_to group_path(@group.id), notice: "グループに参加しました"

    when "text_input"
      @group_membership = @group.group_memberships.build(group_nickname: params[:group_nickname], role: "member")
      if user_signed_in?
        @group_membership.user_id = current_user.id
      else
        @group_membership.guest_token = @group_membership.generate_guest_token
      end

      if @group_membership.save
        # ゲストの場合、トークンを Cookie に保存
        if @group_membership.guest_token.present?
          # 初回参加は空のハッシュ、cookieが残っていればcookieのハッシュ（JSON文字列からパース）
          guest_tokens = cookies.encrypted[:guest_tokens] ? JSON.parse(cookies.encrypted[:guest_tokens]) : {}
          # ハッシュに保存 → { "1" => "abc123..." }
          guest_tokens[@group.id.to_s] = @group_membership.guest_token
          # JSON文字列に変換してcookieに保存
          cookies.encrypted[:guest_tokens] = guest_tokens.to_json
        end
        redirect_to group_path(@group.id), notice: "グループに参加しました"
      else
        redirect_to new_membership_path(@group.invite_token), alert: "参加に失敗しました"
      end
    end
  end

  private

  # ストロングパラメータ
  def group_form_params
    params.require(:group_create_form).permit(:name, :trip_name, :start_date, :end_date, :group_nickname)
  end

  def membership_params
    params.permit(:group_nickname, :membership_source, :invite_token)
  end
end
