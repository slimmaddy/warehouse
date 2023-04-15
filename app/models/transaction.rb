class Transaction < ApplicationRecord
  belongs_to :product

  validates :transaction_type, presence: true, inclusion: { in: %w(IMPORT EXPORT) }
  validates :quantity, presence: true
  validates :unit_price, presence: true

  validate :quantity_must_be_less_than_remaining_quantity

  def quantity_must_be_less_than_remaining_quantity
    if transaction_type == 'EXPORT' && quantity > product.remaining_quantity
      errors.add(:quantity, "cannot be greater than the remaining quantity of #{product.name}")
    end
  end
end
