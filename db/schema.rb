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

ActiveRecord::Schema.define(version: 2022_01_06_144910) do

  create_table "govwebhooks", force: :cascade do |t|
    t.text "data"
    t.integer "nggovcheck_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["nggovcheck_id"], name: "index_govwebhooks_on_nggovcheck_id"
  end

  create_table "identities", force: :cascade do |t|
    t.string "verification_id"
    t.string "document"
    t.boolean "expired"
    t.text "flow"
    t.string "identity"
    t.text "input"
    t.text "metadata"
    t.text "step"
    t.text "device_fingerprint"
    t.boolean "has_problem"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "nggovchecks", force: :cascade do |t|
    t.string "user"
    t.string "phone"
    t.string "bvn"
    t.string "bvn_name"
    t.string "bvn_phone"
    t.string "bvn_dob"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "webhooks", force: :cascade do |t|
    t.text "data"
    t.integer "identity_id"
    t.integer "nggovcheck_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["identity_id"], name: "index_webhooks_on_identity_id"
    t.index ["nggovcheck_id"], name: "index_webhooks_on_nggovcheck_id"
  end

end
