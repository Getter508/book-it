FactoryBot.define do
  factory :to_read_book do
    rank { nil }

    user
    book
  end
end
