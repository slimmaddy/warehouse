class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :quantity
      t.decimal :unit_price

      t.timestamps
    end
  end
end
