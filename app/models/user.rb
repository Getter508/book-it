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

  def update_ranks(book_id, old_rank, new_rank)
    return true if old_rank.nil? && new_rank.nil?

    if old_rank.nil? && new_rank.present?
      add_one_to_ranked_books(new_rank)
    elsif old_rank.present? && new_rank.nil?
      minus_one_from_ranked_books(old_rank)
    elsif old_rank < new_rank.to_i
      demote_rank(old_rank, new_rank)
    else
      promote_rank(old_rank, new_rank)
    end

    to_read_books.find_by(book_id: book_id).update(rank: new_rank)
  end

  def add_one_to_ranked_books(new_rank)
    to_read_books.where("rank >= ?", new_rank.to_i).each do |to_read_book|
      to_read_book.increment_rank!
    end
  end

  def minus_one_from_ranked_books(old_rank)
    to_read_books.where("rank > ?", old_rank).each do |to_read_book|
      to_read_book.decrement_rank!
    end
  end

  def demote_rank(old_rank, new_rank)
    to_read_books.where("? < rank", old_rank.to_i).where("rank <= ?", new_rank.to_i).each do |to_read_book|
      to_read_book.decrement_rank!
    end
  end

  def promote_rank(old_rank, new_rank)
    to_read_books.where("? <= rank", new_rank.to_i).where("rank < ?", old_rank).each do |to_read_book|
      to_read_book.increment_rank!
    end
  end
end

# reorder list such that lowest is set to 1, and so on?
