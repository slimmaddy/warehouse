class Product < ApplicationRecord
  belongs_to :category
  has_many :transactions

  validates :sku, presence:true, uniqueness: true, length: { maximum: 8 }
  validates :name, presence: true
  validates :product_code, presence: true, length: { maximum: 8 }
  validates :size, presence: true
  validates :color, presence: true

  # Validate uniqueness of product_code, size, and color combination
  validates :product_code, uniqueness: { scope: [:size, :color], message: "Should have a unique combination of size and color" }

  def self.upload_images_to_google_drive(images, google_drive)
    return [] unless images.present?
    uploaded_images = []

    images.each do |image|
      file_metadata = {
        name: image.original_filename,
        mime_type: image.content_type,
        parents: [ENV['IMAGE_FOLDER_ID']]
      }
      file = GoogleDrive::File.new(file_metadata)

      uploaded_file = google_drive.create_file(file, upload_source: StringIO.new(image.read), content_type: image.content_type)
      permission = Google::Apis::DriveV3::Permission.new(role: 'reader', type: 'anyone')
      google_drive.create_permission(uploaded_file.id, permission)
      uploaded_images << "https://drive.google.com/uc?id=#{uploaded_file.id}"
    end

    uploaded_images
  end

  def self.remove_images_from_google_drive(image_urls, google_drive)
    image_urls.each do |url|
      file_id = url.split('=').last
      google_drive.delete_file(file_id)
    end
  end

  def remaining_quantity
    import_quantity = self.transactions.where(transaction_type: 'IMPORT').sum(:quantity)
    export_quantity = self.transactions.where(transaction_type: 'EXPORT').sum(:quantity)
    import_quantity - export_quantity
  end

  def average_unit_price_by_type
    result = self.transactions.group(:transaction_type).select("transaction_type, SUM(quantity * unit_price) as total_value, SUM(quantity) as total_quantity")

    average_prices = {}
    result.each do |row|
      transaction_type = row.transaction_type
      total_value = row.total_value.to_f
      total_quantity = row.total_quantity.to_f

      average_prices[transaction_type] = total_quantity.zero? ? 0 : total_value / total_quantity
    end

    average_prices
  end

  def revenue
    import_value = self.transactions.where(transaction_type: 'IMPORT').sum('quantity * unit_price')
    export_value = self.transactions.where(transaction_type: 'EXPORT').sum('quantity * unit_price')
    export_value - import_value
  end
end
