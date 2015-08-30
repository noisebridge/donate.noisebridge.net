# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150830224955) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "charges", force: :cascade do |t|
    t.integer  "donor_id",                     null: false
    t.integer  "amount",                       null: false
    t.string   "stripe_charge_id", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subscription_id"
  end

  create_table "donors", force: :cascade do |t|
    t.string   "email",                  limit: 255,                 null: false
    t.string   "stripe_customer_id",     limit: 255,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 120
    t.boolean  "anonymous",                          default: false
    t.string   "encrypted_password",                 default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "donors", ["email"], name: "index_donors_on_email", unique: true, using: :btree
  add_index "donors", ["reset_password_token"], name: "index_donors_on_reset_password_token", unique: true, using: :btree

  create_table "stripe_plans", force: :cascade do |t|
    t.string   "stripe_id",  limit: 255
    t.string   "name",       limit: 255, null: false
    t.integer  "amount",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stripe_plans", ["stripe_id"], name: "index_stripe_plans_on_stripe_id", unique: true, using: :btree

  create_table "stripe_subscriptions", force: :cascade do |t|
    t.string   "stripe_status",             limit: 255
    t.datetime "cancellation_requested_at"
    t.datetime "cancelled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "donor_id",                                              null: false
    t.integer  "plan_id",                                               null: false
    t.string   "stripe_subscription_id",    limit: 255,                 null: false
    t.boolean  "dues",                                  default: false, null: false
  end

end
