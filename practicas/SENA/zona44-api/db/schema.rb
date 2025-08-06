# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_06_060835) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "adicionals", force: :cascade do |t|
    t.string "nombre", null: false
    t.decimal "precio", precision: 10, scale: 2
    t.string "imagen"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "detalle_adicionals", force: :cascade do |t|
    t.bigint "detalle_pedido_id", null: false
    t.bigint "adicional_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adicional_id"], name: "index_detalle_adicionals_on_adicional_id"
    t.index ["detalle_pedido_id"], name: "index_detalle_adicionals_on_detalle_pedido_id"
  end

  create_table "detalle_pedidos", force: :cascade do |t|
    t.bigint "pedido_id", null: false
    t.bigint "producto_id", null: false
    t.integer "cantidad", default: 1
    t.decimal "subtotal", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pedido_id"], name: "index_detalle_pedidos_on_pedido_id"
    t.index ["producto_id"], name: "index_detalle_pedidos_on_producto_id"
  end

  create_table "grupos", force: :cascade do |t|
    t.string "nombre", null: false
    t.string "imagen"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pedidos", force: :cascade do |t|
    t.bigint "usuario_id", null: false
    t.decimal "total", precision: 10, scale: 2, default: "0.0"
    t.integer "estado", default: 0
    t.integer "metodo_entrega"
    t.boolean "pagado", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["usuario_id"], name: "index_pedidos_on_usuario_id"
  end

  create_table "precio_por_tamanos", force: :cascade do |t|
    t.bigint "producto_id", null: false
    t.bigint "tamano_pizza_id", null: false
    t.decimal "precio", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["producto_id", "tamano_pizza_id"], name: "index_precio_por_tamanos_on_producto_id_and_tamano_pizza_id", unique: true
    t.index ["producto_id"], name: "index_precio_por_tamanos_on_producto_id"
    t.index ["tamano_pizza_id"], name: "index_precio_por_tamanos_on_tamano_pizza_id"
  end

  create_table "producto_adicionals", force: :cascade do |t|
    t.bigint "producto_id", null: false
    t.bigint "adicional_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adicional_id"], name: "index_producto_adicionals_on_adicional_id"
    t.index ["producto_id", "adicional_id"], name: "index_producto_adicionals_on_producto_id_and_adicional_id", unique: true
    t.index ["producto_id"], name: "index_producto_adicionals_on_producto_id"
  end

  create_table "productos", force: :cascade do |t|
    t.string "nombre", null: false
    t.text "descripcion"
    t.string "imagen"
    t.bigint "grupo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grupo_id"], name: "index_productos_on_grupo_id"
  end

  create_table "tamano_pizzas", force: :cascade do |t|
    t.string "nombre", null: false
    t.integer "porciones", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "nombre"
    t.string "email", null: false
    t.string "password_digest", null: false
    t.integer "rol", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_usuarios_on_email", unique: true
  end

  add_foreign_key "detalle_adicionals", "adicionals"
  add_foreign_key "detalle_adicionals", "detalle_pedidos"
  add_foreign_key "detalle_pedidos", "pedidos"
  add_foreign_key "detalle_pedidos", "productos"
  add_foreign_key "pedidos", "usuarios"
  add_foreign_key "precio_por_tamanos", "productos"
  add_foreign_key "precio_por_tamanos", "tamano_pizzas"
  add_foreign_key "producto_adicionals", "adicionals"
  add_foreign_key "producto_adicionals", "productos"
  add_foreign_key "productos", "grupos"
end
