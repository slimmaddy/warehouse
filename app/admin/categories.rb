ActiveAdmin.register Category do
  permit_params :name, :description, sizes_attributes: [:id, :name, :_destroy], colors_attributes: [:id, :name, :_destroy]

  index do
    selectable_column
    id_column
    column :name
    column :description
    actions
  end

  filter :name

  form do |f|
    f.inputs "Category Details" do
      f.input :name
      f.input :description
    end

    f.has_many :sizes, heading: 'Sizes', allow_destroy: true, new_record: true do |b|
      b.input :name
    end

    f.has_many :colors, heading: 'Colors', allow_destroy: true, new_record: true do |b|
      b.input :name
    end
    f.actions
  end

  show do |category|
    attributes_table do
      row :name
      row :description
      row :created_at
      row :updated_at
      row "Sizes" do
        category.sizes.map { |size| size.name }.join(', ').html_safe
      end
      row "Colors" do
        category.colors.map { |color| color.name }.join(', ').html_safe
      end
    end
    active_admin_comments
  end
end
