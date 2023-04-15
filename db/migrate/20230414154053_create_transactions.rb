class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.string :transaction_type
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.datetime :date

      t.timestamps
    end
  end
end
