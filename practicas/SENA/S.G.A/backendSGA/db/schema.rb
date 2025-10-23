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

ActiveRecord::Schema[8.0].define(version: 2025_10_23_041017) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "aprendizs", force: :cascade do |t|
    t.string "nombre", null: false
    t.string "tipodocumento", null: false
    t.integer "ndocumento", null: false
    t.string "correo", null: false
    t.bigint "ficha_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ficha_id"], name: "index_aprendizs_on_ficha_id"
    t.index ["tipodocumento", "ndocumento"], name: "index_aprendizs_on_tipodocumento_and_ndocumento", unique: true
  end

  create_table "asignacion_fichas", force: :cascade do |t|
    t.integer "instructorid", null: false
    t.integer "fichaid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["instructorid", "fichaid"], name: "index_instructor_ficha_unique", unique: true
  end

  create_table "asignaturas", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_asignaturas_on_nombre", unique: true
  end

  create_table "asistencias", force: :cascade do |t|
    t.date "fecha", null: false
    t.string "estado", null: false
    t.integer "aprendizid", null: false
    t.integer "asignacionid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aprendizid", "asignacionid", "fecha"], name: "index_asistencias_unique", unique: true
  end

  create_table "fichas", force: :cascade do |t|
    t.string "codigo", null: false
    t.string "nombre", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_fichas_on_codigo", unique: true
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "nombre", null: false
    t.string "email", null: false
    t.string "rol", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "asignatura_id"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["asignatura_id"], name: "index_usuarios_on_asignatura_id"
    t.index ["confirmation_token"], name: "index_usuarios_on_confirmation_token", unique: true
    t.index ["email"], name: "index_usuarios_on_email", unique: true
    t.index ["reset_password_token"], name: "index_usuarios_on_reset_password_token", unique: true
    t.index ["rol"], name: "index_usuarios_on_rol"
    t.index ["unconfirmed_email"], name: "index_usuarios_on_unconfirmed_email"
  end

  add_foreign_key "aprendizs", "fichas"
  add_foreign_key "asignacion_fichas", "fichas", column: "fichaid"
  add_foreign_key "asignacion_fichas", "usuarios", column: "instructorid"
  add_foreign_key "asistencias", "aprendizs", column: "aprendizid"
  add_foreign_key "asistencias", "asignacion_fichas", column: "asignacionid"
  add_foreign_key "usuarios", "asignaturas"
end
