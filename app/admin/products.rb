ActiveAdmin.register Product do
  permit_params :sku, :name, :category_id, :description, :images

  index do
    selectable_column
    id_column
    column :sku
    column :name
    column :category
    column :description
    column :images do |product|
      if product.images.present?
        first_image_url = product.images.split(",").first
        img src: first_image_url, style: "width: 100px; height: auto;"
      else
        "No Image"
      end
    end
    column :remaining_quantity
    actions
  end

  filter :sku
  filter :name
  filter :category

  form do |f|
    f.inputs "Product Details" do
      f.input :sku
      f.input :name
      f.input :category, include_blank: false
      f.input :description
      f.input :images, as: :hidden
      # Display the current images
      if f.object.images.present?
        f.object.images.split(",").each do |image_url|
          div do
              img src: image_url, style: "width: 200px; height: auto; margin: 5px;"
              button 'Remove', type: 'button', class: 'remove-image', "data-url": image_url, style: "margin-left: 10px;"
          end
        end
      end
      # Hidden input field for removed images
      f.input :removed_images, as: :hidden, input_html: { value: params[:product]&.[](:removed_images) || "" }
      f.input :image_files, as: :file, input_html: { multiple: true }, label: 'Upload Images'
    end
    f.actions
  end

  show do
    attributes_table do
      row :sku
      row :name
      row :category
      row :description
      row :images do |product|
        div do
          product.images.split(",").each do |image_url|
              img src: image_url, style: "width: 200px; height: auto; margin: 5px;"
          end
        end
      end
    end
    active_admin_comments # Add this line for comment block
  end

  controller do
    def create
      params[:product][:images] = Product.upload_images_to_google_drive(params[:product].delete(:image_files), google_drive_service).join(",")
      super
    end

    def update
      # Handle image removal
      if params[:product][:removed_images].present?
        removed_images = params[:product][:removed_images].split(',')
        Product.remove_images_from_google_drive(removed_images, google_drive_service)
        existing_images = params[:product][:images] ? params[:product][:images].split(",") : []
        params[:product][:images] = existing_images.reject { |url| removed_images.include?(url) }.join(",")
      end
      # Handle adding new images
      if params[:product][:image_files].present?
        new_images = Product.upload_images_to_google_drive(params[:product].delete(:image_files), google_drive_service)
        # Combine existing and new images
        existing_images = params[:product][:images] ? params[:product][:images].split(",") : []
        combined_images = existing_images + new_images
        params[:product][:images] = combined_images.join(",") unless combined_images.empty?
      end
      super
    end
  end
end