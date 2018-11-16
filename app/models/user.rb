class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  has_many :have_read_books

  validates_presence_of :first_name, :last_name, :admin, :username
  validates_uniqueness_of :username

  mount_uploader :avatar, ImageUploader
end
