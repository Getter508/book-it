FactoryBot.define do
  factory :author do
    sequence(:name) { |n| "Patrick Rothfuss#{n}" }
  end
end
