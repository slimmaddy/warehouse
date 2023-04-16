class Category < ApplicationRecord
  has_many :products

  validates :name, presence: true
  has_many :sizes
  has_many :colors
  accepts_nested_attributes_for :sizes, allow_destroy: true
  accepts_nested_attributes_for :colors, allow_destroy: true
end
