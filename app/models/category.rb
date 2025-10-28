# == Schema Information
#
# Table name: categories
#
#  id            :bigint           not null, primary key
#  display_order :integer          not null
#  name          :string(20)       not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_categories_on_display_order  (display_order) UNIQUE
#
class Category < ApplicationRecord
  # そのカテゴリのスポットがある場合、カテゴリの削除時にエラー
  has_many :spots, dependent: :restrict_with_error
  validates :name, presence: true, length: { maximum: 20 }
  validates :display_order, presence: true, uniqueness: true
end
