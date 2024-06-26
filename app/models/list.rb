class List < ApplicationRecord
  belongs_to :user
  has_many :list_movies, dependent: :destroy
  has_many :movies, through: :list_movies, source: :movie

  validates :name, presence: true
end
