ActiveAdmin.register Category do
  permit_params :name, :description

  index do
    selectable_column
    id_column
    column :name
    column :description
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
    end
    panel "Products" do
      paginated_collection(category.products.page(params[:page]).per(5)) do
        table_for collection do
          column :product_code
          column :name
          column :sku
          column :size
          column :color
        end
      end
    end
    active_admin_comments # Add this line for comment block
  end

  filter :name

  form do |f|
    f.inputs "Category Details" do
      f.input :name
      f.input :description
    end
    f.actions
  end
end
