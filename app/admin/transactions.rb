ActiveAdmin.register Transaction do
  config.sort_order = 'created_at_desc'
  permit_params :transaction_type, :product_id, :quantity, :unit_price

  index do
    selectable_column
    id_column
    column :transaction_type
    column :product do |t|
      link_to "#{t.product.name}|#{t.product.size}|#{t.product.color}", admin_product_path(t.product)
    end
    column :quantity
    column :unit_price do |t|
      number_to_currency(t.unit_price, unit: "₫", precision: 0)
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :transaction_type
      row :product do |t|
        link_to "#{t.product.name}|#{t.product.size}|#{t.product.color}", admin_product_path(t.product)
      end
      row :quantity
      row :unit_price do |t|
        number_to_currency(t.unit_price, unit: "₫", precision: 0)
      end
    end
    active_admin_comments # Add this line for comment block
  end

  filter :transaction_type, as: :select, collection: %w(IMPORT EXPORT)
  filter :product, as: :select, collection: Product.all.map{ |p| ["#{p.name}|#{p.size}|#{p.color}", p.id] }
  filter :quantity
  filter :unit_price

  form do |f|
    f.inputs "Transaction Details" do
      f.input :transaction_type, include_blank: false, as: :select, collection: %w(IMPORT EXPORT)
      f.input :product, include_blank: false, as: :select, collection: Product.all.map{ |p| ["#{p.name}|#{p.size}|#{p.color}", p.id] }
      f.input :quantity
      f.input :unit_price
      span "Formatted Price: ", id: "formatted-price"
    end
    f.actions

    f.script do
      raw(
        <<-JS
        function formatPrice() {
          var unitPriceInput = document.getElementById("transaction_unit_price");
          var formattedPriceSpan = document.getElementById("formatted-price");
          
          var unitPriceValue = parseFloat(unitPriceInput.value);
          if (isNaN(unitPriceValue)) {
            formattedPriceSpan.textContent = "Formatted Price: ";
          } else {
            formattedPriceSpan.textContent = "Formatted Price: ₫" + unitPriceValue.toLocaleString('en-US');
          }
        }

        // Add event listener to the unit_price input field
        document.getElementById("transaction_unit_price").addEventListener("input", formatPrice);
      JS
      )
    end
  end
end