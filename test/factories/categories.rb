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
FactoryBot.define do
  factory :category do
    
  end
end
