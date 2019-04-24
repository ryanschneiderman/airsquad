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

ActiveRecord::Schema.define(version: 2019_04_24_161541) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.date "date"
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "opponent_id"
    t.index ["team_id"], name: "index_games_on_team_id"
  end

  create_table "group_conversations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_conversations_users", id: false, force: :cascade do |t|
    t.integer "conversation_id"
    t.integer "user_id"
    t.index ["conversation_id"], name: "index_group_conversations_users_on_conversation_id"
    t.index ["user_id"], name: "index_group_conversations_users_on_user_id"
  end

  create_table "group_messages", force: :cascade do |t|
    t.string "content"
    t.string "added_new_users"
    t.string "seen_by"
    t.bigint "user_id"
    t.bigint "conversation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_group_messages_on_conversation_id"
    t.index ["user_id"], name: "index_group_messages_on_user_id"
  end

  create_table "members", force: :cascade do |t|
    t.boolean "isPlayer", default: false
    t.boolean "isAdmin", default: false
    t.boolean "isCreator", default: false
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "team_id"
    t.index ["team_id"], name: "index_members_on_team_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "opponents", force: :cascade do |t|
    t.string "name"
    t.bigint "game_id"
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_opponents_on_game_id"
    t.index ["team_id"], name: "index_opponents_on_team_id"
  end

  create_table "plays", force: :cascade do |t|
    t.string "name"
    t.boolean "offense_defense"
    t.boolean "halfcourt_fullcourt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "num_progressions"
    t.index ["user_id"], name: "index_plays_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.bigint "team_id"
    t.bigint "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_posts_on_member_id"
    t.index ["team_id"], name: "index_posts_on_team_id"
  end

  create_table "private_conversations", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "sender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id", "sender_id"], name: "index_private_conversations_on_recipient_id_and_sender_id", unique: true
    t.index ["recipient_id"], name: "index_private_conversations_on_recipient_id"
    t.index ["sender_id"], name: "index_private_conversations_on_sender_id"
  end

  create_table "private_messages", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id"
    t.bigint "conversation_id"
    t.boolean "seen", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_private_messages_on_conversation_id"
    t.index ["user_id"], name: "index_private_messages_on_user_id"
  end

  create_table "progressions", force: :cascade do |t|
    t.string "json_diagram"
    t.integer "index"
    t.bigint "play_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["play_id"], name: "index_progressions_on_play_id"
  end

  create_table "stat_granules", force: :cascade do |t|
    t.string "metadata"
    t.bigint "game_id"
    t.bigint "stat_list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "member_id"
    t.bigint "opponent_id"
    t.index ["game_id"], name: "index_stat_granules_on_game_id"
    t.index ["member_id"], name: "index_stat_granules_on_member_id"
    t.index ["opponent_id"], name: "index_stat_granules_on_opponent_id"
    t.index ["stat_list_id"], name: "index_stat_granules_on_stat_list_id"
  end

  create_table "stat_lists", force: :cascade do |t|
    t.string "stat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "granular"
    t.boolean "advanced"
    t.boolean "default"
    t.boolean "collectable"
    t.boolean "team_stat"
    t.integer "display_priority"
  end

  create_table "stat_totals", force: :cascade do |t|
    t.bigint "stat_list_id"
    t.bigint "team_id"
    t.bigint "game_id"
    t.integer "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_stat_totals_on_game_id"
    t.index ["stat_list_id"], name: "index_stat_totals_on_stat_list_id"
    t.index ["team_id"], name: "index_stat_totals_on_team_id"
  end

  create_table "stats", force: :cascade do |t|
    t.integer "value"
    t.bigint "stat_list_id"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "member_id"
    t.bigint "opponent_id"
    t.index ["game_id"], name: "index_stats_on_game_id"
    t.index ["member_id"], name: "index_stats_on_member_id"
    t.index ["opponent_id"], name: "index_stats_on_opponent_id"
    t.index ["stat_list_id"], name: "index_stats_on_stat_list_id"
  end

  create_table "team_plays", force: :cascade do |t|
    t.bigint "play_id"
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["play_id"], name: "index_team_plays_on_play_id"
    t.index ["team_id"], name: "index_team_plays_on_team_id"
  end

  create_table "team_stats", force: :cascade do |t|
    t.bigint "stat_list_id"
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "show"
    t.boolean "favorite"
    t.index ["stat_list_id"], name: "index_team_stats_on_stat_list_id"
    t.index ["team_id"], name: "index_team_stats_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state"
    t.string "region"
    t.integer "division"
    t.string "primary_color"
    t.string "secondary_color"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "private_messages", "users"
end
