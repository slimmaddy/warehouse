class Product < ApplicationRecord
  belongs_to :category
  has_many :transactions

  validates :sku, presence:true, uniqueness: true, length: { maximum: 8 }
  validates :name, presence: true

  def self.upload_images_to_google_drive(images, google_drive)
    return [] unless images.present?
    uploaded_images = []

    images.each do |image|
      file_metadata = {
        name: image.original_filename,
        mime_type: image.content_type,
        parents: ['1roeR2JA26hqpdeW1wMoOcCvIbRRnDBPd']
      }
      file = GoogleDrive::File.new(file_metadata)

      uploaded_file = google_drive.create_file(file, upload_source: StringIO.new(image.read), content_type: image.content_type)
      google_drive.update_file(uploaded_file.id, { 'permissions' => [{ 'role' => 'reader', 'type' => 'anyone' }] })
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
end
