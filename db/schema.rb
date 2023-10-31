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

ActiveRecord::Schema[7.0].define(version: 2023_10_31_115313) do
  create_table "billed_products", force: :cascade do |t|
    t.integer "quantity"
    t.decimal "purchased_price"
    t.decimal "tax_payable"
    t.decimal "total_price"
    t.integer "bill_id", null: false
    t.integer "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bill_id"], name: "index_billed_products_on_bill_id"
    t.index ["product_id"], name: "index_billed_products_on_product_id"
  end

  create_table "bills", force: :cascade do |t|
    t.string "customer_email"
    t.float "customer_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.decimal "unit_price"
    t.float "tax_percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "billed_products", "bills"
  add_foreign_key "billed_products", "products"
end
