# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
if Rails.env.production?
  email = ENV['ADMIN_EMAIL']
  password = ENV['ADMIN_PASSWORD']
  if email.present? && password.present?
    admin = AdminUser.find_or_initialize_by(email: email)
    admin.password = password
    admin.password_confirmation = password
    admin.save!
  else
    raise 'ADMIN_EMAIL and ADMIN_PASSWORD must be set in production environment'
  end
end