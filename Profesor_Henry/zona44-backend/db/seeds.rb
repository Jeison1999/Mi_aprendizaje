# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Creando usuario de prueba..."
unless User.exists?(email: "jeison@zona44.com")
  User.create!(
    name: "Jeison",
    email: "jeison@zona44.com",
    password: "123456",
    password_confirmation: "123456",
    role: :admin # o :cliente
  )
  puts "Usuario creado exitosamente"
else
  puts "El usuario de prueba ya existe"
end

puts "Creando grupo de productos de prueba..."
group = Group.find_or_create_by!(name: "Comidas Rápidas")
puts "Grupo creado exitosamente"

puts "Creando producto de prueba..."
Product.create!(
  name: "Hamburguesa Clásica",
  description: "Hamburguesa con carne 100% res, queso y vegetales frescos",
  price: 10000,
  group: group
)
puts "Producto creado exitosamente"
