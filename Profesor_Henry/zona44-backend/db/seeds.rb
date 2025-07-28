# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   endjeison@zona44.com

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

puts "Creando tamaños de pizza..."
pizza_sizes = [
  { name: "Personal", slices: 4, diameter: 20, base_price: 15000 },
  { name: "Pequeña", slices: 6, diameter: 25, base_price: 20000 },
  { name: "Mediana", slices: 8, diameter: 30, base_price: 25000 },
  { name: "Grande", slices: 10, diameter: 35, base_price: 30000 },
  { name: "Familiar", slices: 12, diameter: 40, base_price: 35000 }
]

pizza_sizes.each do |size_data|
  PizzaSize.find_or_create_by!(name: size_data[:name]) do |size|
    size.slices = size_data[:slices]
    size.diameter = size_data[:diameter]
    size.base_price = size_data[:base_price]
  end
end
puts "Tamaños de pizza creados exitosamente"

puts "Creando ingredientes..."
ingredients = [
  { name: "Queso Mozzarella", prices_by_size: { "Personal" => 2000, "Pequeña" => 3000, "Mediana" => 4000, "Grande" => 5000, "Familiar" => 6000 }, is_available: true },
  { name: "Pepperoni", prices_by_size: { "Personal" => 3000, "Pequeña" => 4000, "Mediana" => 5000, "Grande" => 6000, "Familiar" => 7000 }, is_available: true },
  { name: "Jamón", prices_by_size: { "Personal" => 2500, "Pequeña" => 3500, "Mediana" => 4500, "Grande" => 5500, "Familiar" => 6500 }, is_available: true },
  { name: "Champiñones", prices_by_size: { "Personal" => 1500, "Pequeña" => 2000, "Mediana" => 2500, "Grande" => 3000, "Familiar" => 3500 }, is_available: true },
  { name: "Pimientos", prices_by_size: { "Personal" => 1000, "Pequeña" => 1500, "Mediana" => 2000, "Grande" => 2500, "Familiar" => 3000 }, is_available: true },
  { name: "Cebolla", prices_by_size: { "Personal" => 1000, "Pequeña" => 1500, "Mediana" => 2000, "Grande" => 2500, "Familiar" => 3000 }, is_available: true },
  { name: "Aceitunas", prices_by_size: { "Personal" => 1500, "Pequeña" => 2000, "Mediana" => 2500, "Grande" => 3000, "Familiar" => 3500 }, is_available: true },
  { name: "Salami", prices_by_size: { "Personal" => 3000, "Pequeña" => 4000, "Mediana" => 5000, "Grande" => 6000, "Familiar" => 7000 }, is_available: true }
]

ingredients.each do |ingredient_data|
  Ingredient.find_or_create_by!(name: ingredient_data[:name]) do |ingredient|
    ingredient.prices_by_size = ingredient_data[:prices_by_size]
    ingredient.is_available = ingredient_data[:is_available]
  end
end
puts "Ingredientes creados exitosamente"
