require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.select_options' do
    it 'creates an alphabetical list of entries with genre name and id' do
      genre = create(:genre)
      genre2 = create(:genre, name: 'Adventure')
      genre3 = create(:genre, name: 'Dystopias')
      genre4 = create(:genre, name: 'Non-Fiction')

      expect(Genre.select_options).to eq([
        [genre2.name, genre2.id],
        [genre3.name, genre3.id],
        [genre.name, genre.id],
        [genre4.name, genre4.id]
      ])
    end
  end
end
