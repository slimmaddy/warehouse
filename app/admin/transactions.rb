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