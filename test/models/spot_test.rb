# == Schema Information
#
# Table name: spots
#
#  id              :bigint           not null, primary key
#  address         :text
#  name            :string(50)       not null
#  phone_number    :string(20)
#  website_url     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  card_id         :bigint           not null
#  google_place_id :string
#
# Indexes
#
#  index_spots_on_card_id          (card_id)
#  index_spots_on_google_place_id  (google_place_id) UNIQUE WHERE (google_place_id IS NOT NULL)
#
# Foreign Keys
#
#  fk_rails_...  (card_id => cards.id)
#
require "test_helper"

class SpotTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
