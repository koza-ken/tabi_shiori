# == Schema Information
#
# Table name: group_memberships
#
#  id             :bigint           not null, primary key
#  group_nickname :string(20)
#  guest_token    :string(64)
#  role           :string           default("member"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  group_id       :bigint           not null
#  user_id        :bigint
#
# Indexes
#
#  index_group_memberships_on_group_id                     (group_id)
#  index_group_memberships_on_group_id_and_group_nickname  (group_id,group_nickname) UNIQUE
#  index_group_memberships_on_guest_token                  (guest_token)
#  index_group_memberships_on_user_id                      (user_id)
#  index_group_memberships_on_user_id_and_group_id         (user_id,group_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#
class GroupMembership < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :group
  validates :group_nickname, presence: true, uniqueness: { scope: :group_id }, length: { maximum: 20 }
  validates :guest_token, length: { maximum: 64 }, allow_blank: true
  # user_id または guest_token のどちらかが必須
  validate :must_have_user_or_guest_token

  enum :role, { member: "member", owner: "owner" }

  # ゲストトークンの生成
  def generate_guest_token
    self.guest_token ||= SecureRandom.urlsafe_base64(32)
  end

  # ログインユーザーがグループのメンバーか確認
  def self.user_member?(user, group)
    exists?(user: user, group: group)
  end


  private

  def must_have_user_or_guest_token
    if user_id.blank? && guest_token.blank?
      errors.add(:base, "ユーザーまたはゲストトークンのどちらかが必要です")
    end
  end
end
