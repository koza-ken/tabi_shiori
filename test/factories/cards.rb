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
FactoryBot.define do
  factory :card do
    
  end
end
