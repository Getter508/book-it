FactoryBot.define do
  factory :have_read_book do
    date_completed { DateTime.current }

    user
    book
  end
end
