ActiveAdmin.register Transaction do
  permit_params :transaction_type, :product_id, :quantity, :unit_price

  index do
    selectable_column
    id_column
    column :transaction_type
    column :product
    column :quantity
    column :unit_price
    actions
  end

  filter :transaction_type, as: :select, collection: %w(IMPORT EXPORT)
  filter :product
  filter :quantity

  form do |f|
    f.inputs "Transaction Details" do
      f.input :transaction_type, include_blank: false, as: :select, collection: %w(IMPORT EXPORT)
      f.input :product, include_blank: false, as: :select, collection: Product.all.map{ |p| ["#{p.sku} - #{p.name}", p.id] }
      f.input :quantity
      f.input :unit_price
    end
    f.actions
  end
end