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

ActiveRecord::Schema.define(version: 2020_05_22_144420) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "advanced_stats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "stat_list_id"
    t.bigint "member_id"
    t.bigint "game_id"
    t.float "value"
    t.json "constituent_stats"
    t.index ["game_id"], name: "index_advanced_stats_on_game_id"
    t.index ["member_id"], name: "index_advanced_stats_on_member_id"
    t.index ["stat_list_id"], name: "index_advanced_stats_on_stat_list_id"
  end

  create_table "assignments", force: :cascade do |t|
    t.bigint "member_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_assignments_on_member_id"
    t.index ["role_id"], name: "index_assignments_on_role_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "member_id"
    t.bigint "post_id"
    t.index ["member_id"], name: "index_comments_on_member_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "opponent_id"
    t.boolean "played"
    t.bigint "schedule_event_id"
    t.json "game_state"
    t.index ["schedule_event_id"], name: "index_games_on_schedule_event_id"
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

  create_table "lineup_adv_stats", force: :cascade do |t|
    t.bigint "stat_list_id"
    t.bigint "lineup_id"
    t.json "constituent_stats"
    t.integer "rank"
    t.float "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_opponent"
    t.index ["lineup_id"], name: "index_lineup_adv_stats_on_lineup_id"
    t.index ["stat_list_id"], name: "index_lineup_adv_stats_on_stat_list_id"
  end

  create_table "lineup_game_advanced_stats", force: :cascade do |t|
    t.float "value"
    t.bigint "lineup_id"
    t.bigint "stat_list_id"
    t.bigint "game_id"
    t.json "constituent_stats"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_opponent"
    t.index ["game_id"], name: "index_lineup_game_advanced_stats_on_game_id"
    t.index ["lineup_id"], name: "index_lineup_game_advanced_stats_on_lineup_id"
    t.index ["stat_list_id"], name: "index_lineup_game_advanced_stats_on_stat_list_id"
  end

  create_table "lineup_game_stats", force: :cascade do |t|
    t.integer "value"
    t.bigint "lineup_id"
    t.bigint "stat_list_id"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_opponent"
    t.index ["game_id"], name: "index_lineup_game_stats_on_game_id"
    t.index ["lineup_id"], name: "index_lineup_game_stats_on_lineup_id"
    t.index ["stat_list_id"], name: "index_lineup_game_stats_on_stat_list_id"
  end

  create_table "lineup_stats", force: :cascade do |t|
    t.integer "value"
    t.bigint "lineup_id"
    t.bigint "stat_list_id"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_opponent"
    t.index ["lineup_id"], name: "index_lineup_stats_on_lineup_id"
    t.index ["stat_list_id"], name: "index_lineup_stats_on_stat_list_id"
  end

  create_table "lineups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id"
    t.integer "season_minutes"
    t.index ["team_id"], name: "index_lineups_on_team_id"
  end

  create_table "lineups_members", id: false, force: :cascade do |t|
    t.bigint "lineup_id", null: false
    t.bigint "member_id", null: false
    t.index ["lineup_id", "member_id"], name: "index_lineups_members_on_lineup_id_and_member_id"
    t.index ["member_id", "lineup_id"], name: "index_lineups_members_on_member_id_and_lineup_id"
  end

  create_table "member_notifs", force: :cascade do |t|
    t.bigint "member_id"
    t.boolean "viewed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "notification_id"
    t.boolean "read"
    t.jsonb "data", default: "{}"
    t.index ["member_id"], name: "index_member_notifs_on_member_id"
    t.index ["notification_id"], name: "index_member_notifs_on_notification_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "team_id"
    t.integer "season_minutes"
    t.integer "games_played"
    t.index ["team_id"], name: "index_members_on_team_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "content"
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notif_type_type"
    t.bigint "notif_type_id"
    t.jsonb "data", default: "{}"
    t.string "notif_kind"
    t.index ["notif_type_type", "notif_type_id"], name: "index_notifications_on_notif_type_type_and_notif_type_id"
    t.index ["team_id"], name: "index_notifications_on_team_id"
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

  create_table "play_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "play_type"
  end

  create_table "play_views", force: :cascade do |t|
    t.bigint "play_id"
    t.bigint "member_id"
    t.datetime "viewed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_play_views_on_member_id"
    t.index ["play_id"], name: "index_play_views_on_play_id"
  end

  create_table "playlist_associations", force: :cascade do |t|
    t.bigint "play_id"
    t.bigint "playlist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["play_id"], name: "index_playlist_associations_on_play_id"
    t.index ["playlist_id"], name: "index_playlist_associations_on_playlist_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id"
    t.integer "color_scheme"
    t.index ["team_id"], name: "index_playlists_on_team_id"
  end

  create_table "plays", force: :cascade do |t|
    t.string "name"
    t.boolean "offense_defense"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "num_progressions"
    t.bigint "play_type_id"
    t.boolean "deleted_flag"
    t.index ["play_type_id"], name: "index_plays_on_play_type_id"
    t.index ["user_id"], name: "index_plays_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.bigint "team_id"
    t.bigint "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "post_type_type"
    t.bigint "post_type_id"
    t.index ["member_id"], name: "index_posts_on_member_id"
    t.index ["post_type_type", "post_type_id"], name: "index_posts_on_post_type_type_and_post_type_id"
    t.index ["team_id"], name: "index_posts_on_team_id"
  end

  create_table "practice_stat_granules", force: :cascade do |t|
    t.json "metadata"
    t.bigint "practice_id"
    t.bigint "member_id"
    t.bigint "stat_list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_practice_stat_granules_on_member_id"
    t.index ["practice_id"], name: "index_practice_stat_granules_on_practice_id"
    t.index ["stat_list_id"], name: "index_practice_stat_granules_on_stat_list_id"
  end

  create_table "practice_stat_totals", force: :cascade do |t|
    t.integer "value"
    t.bigint "stat_list_id"
    t.bigint "practice_id"
    t.bigint "team_id"
    t.boolean "is_opponent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_id"], name: "index_practice_stat_totals_on_practice_id"
    t.index ["stat_list_id"], name: "index_practice_stat_totals_on_stat_list_id"
    t.index ["team_id"], name: "index_practice_stat_totals_on_team_id"
  end

  create_table "practice_stats", force: :cascade do |t|
    t.integer "value"
    t.bigint "stat_list_id"
    t.bigint "practice_id"
    t.bigint "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_practice_stats_on_member_id"
    t.index ["practice_id"], name: "index_practice_stats_on_practice_id"
    t.index ["stat_list_id"], name: "index_practice_stats_on_stat_list_id"
  end

  create_table "practices", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "schedule_event_id"
    t.boolean "is_scrimmage"
    t.json "game_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "played"
    t.index ["schedule_event_id"], name: "index_practices_on_schedule_event_id"
    t.index ["team_id"], name: "index_practices_on_team_id"
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
    t.float "canvas_width"
    t.text "notes"
    t.index ["play_id"], name: "index_progressions_on_play_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedule_events", force: :cascade do |t|
    t.date "date"
    t.time "time"
    t.string "place"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id"
    t.index ["team_id"], name: "index_schedule_events_on_team_id"
  end

  create_table "season_advanced_stats", force: :cascade do |t|
    t.bigint "stat_list_id"
    t.bigint "member_id"
    t.float "value"
    t.json "constituent_stats"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "team_rank"
    t.index ["member_id"], name: "index_season_advanced_stats_on_member_id"
    t.index ["stat_list_id"], name: "index_season_advanced_stats_on_stat_list_id"
  end

  create_table "season_stats", force: :cascade do |t|
    t.bigint "stat_list_id"
    t.bigint "member_id"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "per_game_rank"
    t.integer "per_minute_rank"
    t.index ["member_id"], name: "index_season_stats_on_member_id"
    t.index ["stat_list_id"], name: "index_season_stats_on_stat_list_id"
  end

  create_table "season_team_adv_stats", force: :cascade do |t|
    t.bigint "stat_list_id"
    t.bigint "team_id"
    t.float "value"
    t.boolean "is_opponent"
    t.json "constituent_stats"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stat_list_id"], name: "index_season_team_adv_stats_on_stat_list_id"
    t.index ["team_id"], name: "index_season_team_adv_stats_on_team_id"
  end

  create_table "stat_granules", force: :cascade do |t|
    t.json "metadata"
    t.bigint "game_id"
    t.bigint "stat_list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "member_id"
    t.index ["game_id"], name: "index_stat_granules_on_game_id"
    t.index ["member_id"], name: "index_stat_granules_on_member_id"
    t.index ["stat_list_id"], name: "index_stat_granules_on_stat_list_id"
  end

  create_table "stat_lists", force: :cascade do |t|
    t.string "stat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default_stat"
    t.boolean "collectable"
    t.boolean "team_stat"
    t.integer "display_priority"
    t.boolean "advanced"
    t.boolean "rankable"
    t.boolean "is_percent"
    t.integer "stat_kind"
    t.text "stat_description"
  end

  create_table "stat_totals", force: :cascade do |t|
    t.bigint "stat_list_id"
    t.bigint "team_id"
    t.bigint "game_id"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_opponent"
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
    t.index ["game_id"], name: "index_stats_on_game_id"
    t.index ["member_id"], name: "index_stats_on_member_id"
    t.index ["stat_list_id"], name: "index_stats_on_stat_list_id"
  end

  create_table "team_advanced_stats", force: :cascade do |t|
    t.bigint "stat_list_id"
    t.bigint "game_id"
    t.json "constituent_stats"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "value"
    t.boolean "is_opponent"
    t.index ["game_id"], name: "index_team_advanced_stats_on_game_id"
    t.index ["stat_list_id"], name: "index_team_advanced_stats_on_stat_list_id"
  end

  create_table "team_plays", force: :cascade do |t|
    t.bigint "play_id"
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["play_id"], name: "index_team_plays_on_play_id"
    t.index ["team_id"], name: "index_team_plays_on_team_id"
  end

  create_table "team_season_stats", force: :cascade do |t|
    t.bigint "stat_list_id"
    t.bigint "team_id"
    t.float "value"
    t.boolean "is_opponent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stat_list_id"], name: "index_team_season_stats_on_stat_list_id"
    t.index ["team_id"], name: "index_team_season_stats_on_team_id"
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
    t.integer "minutes_p_q"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assignments", "members"
  add_foreign_key "assignments", "roles"
  add_foreign_key "private_messages", "users"
end
