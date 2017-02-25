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

ActiveRecord::Schema.define(version: 20170220233007) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "charges", force: :cascade do |t|
    t.integer  "donor_id",         null: false
    t.integer  "amount",           null: false
    t.string   "stripe_charge_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subscription_id"
    t.string   "tag"
  end

  create_table "donors", force: :cascade do |t|
    t.string   "email",                                          null: false
    t.string   "stripe_customer_id",                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",               limit: 120
    t.boolean  "anonymous",                      default: false
  end

  create_table "paypal_notifications", force: :cascade do |t|
    t.string   "notification_id", null: false
    t.json     "payload",         null: false
    t.datetime "processed_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["notification_id"], name: "index_paypal_notifications_on_notification_id", unique: true, using: :btree
  end

  create_table "stripe_events", force: :cascade do |t|
    t.string   "stripe_id",    null: false
    t.json     "body"
    t.datetime "processed_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["stripe_id"], name: "index_stripe_events_on_stripe_id", unique: true, using: :btree
  end

  create_table "stripe_plans", force: :cascade do |t|
    t.string   "stripe_id"
    t.string   "name",       null: false
    t.integer  "amount",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["stripe_id"], name: "index_stripe_plans_on_stripe_id", unique: true, using: :btree
  end

  create_table "stripe_subscriptions", force: :cascade do |t|
    t.string   "stripe_status"
    t.datetime "cancellation_requested_at"
    t.datetime "cancelled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "donor_id",                                  null: false
    t.integer  "plan_id",                                   null: false
    t.string   "stripe_subscription_id",                    null: false
    t.boolean  "dues",                      default: false, null: false
  end

end
