FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "The Name of the Wind#{n}" }
    year { 2007 }
    pages { 800 }
    description { "So begins the tale of Kvothe." }
    cover { "http://covers.openlibrary.org/b/id/8259447-L.jpg" }
  end
end

# NameofWindCover: "http://covers.openlibrary.org/b/id/8259447-L.jpg"
# WiseMansFearCover: "http://covers.openlibrary.org/b/id/8155423-L.jpg"

# cover { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/NameofWindCover.jpg'), 'image/jpeg') }
# cover { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/WiseMansFearCover.jpg'), 'image/jpeg')) }
