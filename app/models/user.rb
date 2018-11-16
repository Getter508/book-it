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
end
