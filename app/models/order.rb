class Order < ApplicationRecord
  before_validation :set_total!
  validates :total, numericality: { greater_than_or_equal_to: 0 }
  validates :total, presence: true

  has_many :placements, dependent: :destroy
  has_many :products, through: :placements
  belongs_to :user

  def set_total!
    self.total = products.sum :price
  end

  # @param product_ids_and_quantities [Array<Hash>] something
  # like this `[{product_id: 1, quantity: 2}]`
  # @yield [Placement] placements build
  def build_placements_with_product_ids_and_quantities(product_ids_and_quantities)
    product_ids_and_quantities.each do |product_id_and_quantity|
      placement = placements.build(
        product_id: product_id_and_quantity[:product_id],
        quantity: product_id_and_quantity[:quantity]
      )
      yield placement if block_given?
    end
  end
end
