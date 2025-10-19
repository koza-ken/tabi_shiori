class GroupCreateForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # フォームオブジェクトのインスタンスにuser属性を持たせる（コントローラからcurrent_userを渡している）
  attr_accessor :user

  # groupsモデル
  attribute :name, :string
  attribute :trip_name, :string
  attribute :start_date, :date
  attribute :end_date, :date
  # group_membershipモデル
  attribute :group_nickname, :string
  attribute :role, :string
  # attr_accessor :user  # current_user をセットするため
  validates :name, :group_nickname, presence: true

  # フォーム内容を保存する処理
  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      group = user.created_groups.build(
        name: name,
        trip_name: trip_name,
        start_date: start_date,
        end_date: end_date
      )
      group.group_memberships.build(
        user_id: user.id,
        group_nickname: group_nickname,
        role: :owner
      )
      group.save!
    end

    true
  # ブロック内で例外が発生すると
  rescue ActiveRecord::RecordInvalid
    false
  end
end
