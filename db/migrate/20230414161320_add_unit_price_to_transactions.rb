class AddUnitPriceToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :unit_price, :decimal
  end
end
