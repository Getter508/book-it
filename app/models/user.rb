class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :trackable :confirmable, :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :have_read_books
  has_many :completed_books, through: :have_read_books, source: :book
  has_many :to_read_books
  has_many :to_complete_books, through: :to_read_books, source: :book

  validates_presence_of :first_name, :last_name, :username
  validates_uniqueness_of :username

  mount_uploader :avatar, ImageUploader

  def update_ranks(book_id, rank)
    result = []
    self.to_read_books.each do |to_read_book|
      to_read_book.rank += 1 if to_read_book.rank.to_i >= rank.to_i
      to_read_book.rank = nil if to_read_book.rank.to_i > 10
      to_read_book.rank = rank if to_read_book.book_id == book_id.to_i
      to_read_book.save
      result << to_read_book.save
    end
    result.all?(true)
  end
end
