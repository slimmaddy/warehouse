class AddFieldsToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :sku, :string
    add_reference :products, :category, null: false, foreign_key: true
  end
end
