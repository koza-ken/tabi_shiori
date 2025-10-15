class Card < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :group, optional: true
  validates :name, presence: true, length: { maximum: 50 }

  # カスタムバリデーション: user_idとgroup_idの排他制約
  validate :must_belong_to_user_or_group

  private

  # エラーは出ることはないけど念のためのバリデーション
  def must_belong_to_user_or_group
    # どちらも無い場合
    if user_id.nil? && group_id.nil?
      errors.add(:base, "ユーザーまたはグループのどちらかに紐づけてください")
    end
    # 両方ある場合
    if user_id.present? && group_id.present?
      errors.add(:base, "ユーザーとグループの両方に紐づけることはできません")
    end
  end
end
