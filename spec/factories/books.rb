FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "The Name of the Wind#{n}" }
    year { 2007 }
    pages { 800 }
    description { "So begins the tale of Kvothe." }
    cover { "http://covers.openlibrary.org/b/id/8259447-L.jpg" }
  end
end
