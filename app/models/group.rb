class Group < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "created_by_user_id", inverse_of: :created_groups
  has_many :cards
  validates :created_by_user_id, presence: true
  validates :name, presence: true, length: { maximum: 30 }
  validates :invite_token, presence: true, length: { maximum: 64 }, uniqueness: true
  validates :trip_name, length: { maximum: 50 }, allow_blank: true

  # 終了日が開始日より後になるように
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    if end_date < start_date
      errors.add(:end_date, "は開始日より後の日付を設定してください")
    end
  end
end
