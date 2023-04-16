class AddSizeColorProductCodeToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :size, :string
    add_column :products, :color, :string
    add_column :products, :product_code, :string, limit: 8

    # Add a unique index for the combination of product_code, size, and color
    add_index :products, [:product_code, :size, :color], unique: true
  end
end
