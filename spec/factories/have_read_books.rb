FactoryBot.define do
  factory :have_read_book do
    date_completed { DateTime.current }
    rating { 9 }
    note { 'Great book' }

    user
    book
  end
end
