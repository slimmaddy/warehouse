class UpdateSkuInProducts < ActiveRecord::Migration[6.1]
  def change
    change_column :products, :sku, :string, limit: 8
    add_index :products, :sku, unique: true
  end
end
