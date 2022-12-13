class Order < ApplicationRecord
  validates :total, numericality: { greater_than_or_equal_to: 0 }
  validates :total, presence: true

  has_many :placements, dependent: :destroy
  has_many :products, through: :placements
  belongs_to :user
end
