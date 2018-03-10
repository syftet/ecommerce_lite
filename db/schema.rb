# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180309051000) do

  create_table "admin_brands", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.string "permalink"
    t.string "meta_title"
    t.string "meta_desc"
    t.string "keywords"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admin_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "slug"
    t.string "description"
    t.string "permalink"
    t.string "meta_title"
    t.string "meta_desc"
    t.string "keywords"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blogs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.text "body"
    t.integer "user_id"
    t.string "cover_photo"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "body"
    t.integer "user_id"
    t.boolean "is_approved"
    t.integer "blog_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "full_name"
    t.string "email"
    t.string "phone"
    t.string "order_number"
    t.string "inquiry_type"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "home_sliders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "sub_title"
    t.string "link"
  end

  create_table "images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "viewable_type"
    t.bigint "viewable_id"
    t.integer "width"
    t.integer "height"
    t.integer "file_size"
    t.integer "position"
    t.string "content_type"
    t.text "file"
    t.string "alt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["viewable_type", "viewable_id"], name: "index_images_on_viewable_type_and_viewable_id"
  end

  create_table "line_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "variant_id"
    t.integer "order_id"
    t.integer "quantity"
    t.float "price", limit: 24, default: 0.0
    t.float "cost_price", limit: 24, default: 0.0
    t.string "currency"
    t.decimal "adjustment_total", precision: 10, default: "0"
    t.decimal "promo_total", precision: 10, default: "0"
    t.string "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "newsletter_subscriptions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "number"
    t.decimal "item_total", precision: 10, default: "0"
    t.decimal "total", precision: 10, default: "0"
    t.string "state"
    t.decimal "adjustment_total", precision: 10, default: "0"
    t.integer "user_id"
    t.datetime "completed_at"
    t.integer "ship_address_id"
    t.decimal "payment_total", precision: 10, default: "0"
    t.string "shipment_state"
    t.string "payment_state"
    t.string "email"
    t.string "currency"
    t.string "created_by_id"
    t.decimal "shipment_total", precision: 10, default: "0"
    t.decimal "promo_total", precision: 10, default: "0"
    t.integer "item_count"
    t.integer "approver_id"
    t.datetime "approved_at"
    t.boolean "confirmation_delivered"
    t.string "guest_token"
    t.datetime "canceled_at"
    t.integer "canceler_id"
    t.integer "store_id"
    t.date "shipment_date"
    t.integer "shipment_progress", default: 0
    t.datetime "shipped_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "product_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_product_categories_on_category_id"
    t.index ["product_id"], name: "index_product_categories_on_product_id"
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "code", null: false
    t.string "name"
    t.text "description"
    t.string "origin"
    t.string "slug"
    t.string "meta_title"
    t.text "meta_desc"
    t.string "keywords"
    t.bigint "brand_id"
    t.boolean "is_featured", default: false, null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "deleted_at"
    t.integer "product_id"
    t.float "sale_price", limit: 53, default: 0.0, null: false
    t.float "cost_price", limit: 53, default: 0.0, null: false
    t.float "whole_sale", limit: 53, default: 0.0, null: false
    t.string "color_name"
    t.string "color"
    t.string "size"
    t.string "weight"
    t.string "width"
    t.string "height"
    t.string "depth"
    t.boolean "discountable", default: false
    t.boolean "is_amount", default: false
    t.float "discount", limit: 53, default: 0.0, null: false
    t.float "reward_point", limit: 53, default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_products_on_brand_id"
  end

  create_table "related_products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "product_id"
    t.integer "relative_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "rating"
    t.text "text"
    t.integer "product_id"
    t.integer "user_id"
    t.string "email"
    t.boolean "is_approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wishlists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "product_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
