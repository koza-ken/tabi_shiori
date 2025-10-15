FactoryBot.define do
  factory :group do
    created_by_user_id { 1 }
    name { "MyString" }
    invite_token { 1 }
    trip_name { "MyString" }
    start_date { "2025-10-15" }
    end_date { "2025-10-15" }
    trip_memo { "MyText" }
  end
end
