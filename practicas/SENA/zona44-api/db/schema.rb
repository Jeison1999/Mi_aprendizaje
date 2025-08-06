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

ActiveRecord::Schema[8.0].define(version: 2025_08_06_154743) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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
    t.decimal "precio", precision: 10, scale: 2
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
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
