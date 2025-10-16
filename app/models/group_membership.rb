class GroupMembership < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :group
  validates :group_nickname, presence: true, uniqueness: { scope: :group_id }, length: { maximum: 20 }
  validates :guest_token, length: { maximum: 64 }, allow_blank: true
  # user_id または guest_token のどちらかが必須
  validate :must_have_user_or_guest_token

  enum :role, { member: "member", owner: "owner" }

  private

  def must_have_user_or_guest_token
    if user_id.blank? && guest_token.blank?
      errors.add(:base, "ユーザーまたはゲストトークンのどちらかが必要です")
    end
  end
end
