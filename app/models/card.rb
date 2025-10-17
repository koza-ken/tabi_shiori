# == Schema Information
#
# Table name: cards
#
#  id         :bigint           not null, primary key
#  memo       :text
#  name       :string(50)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_cards_on_group_id  (group_id)
#  index_cards_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#
class Card < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :group, optional: true
  validates :name, presence: true, length: { maximum: 50 }

  # カスタムバリデーション: user_idとgroup_idの排他制約
  validate :must_belong_to_user_or_group

  private

  def must_belong_to_user_or_group
    # どちらも無い場合
    if user_id.blank? && group_id.blank?
      errors.add(:base, "ユーザーまたはグループのどちらかに紐づけてください")
    end
    # 両方ある場合
    if user_id.present? && group_id.present?
      errors.add(:base, "ユーザーとグループの両方に紐づけることはできません")
    end
  end
end
