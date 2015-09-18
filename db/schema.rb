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

ActiveRecord::Schema.define(version: 20150918141249) do

  create_table "achievements", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "tooltip",                            default: ""
    t.integer  "user_id"
    t.integer  "avatar_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "badge_id"
    t.integer  "thumb_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "badge_file_name"
    t.string   "badge_content_type"
    t.integer  "badge_file_size"
    t.datetime "badge_updated_at"
    t.string   "thumb_file_name"
    t.string   "thumb_content_type"
    t.integer  "thumb_file_size"
    t.datetime "thumb_updated_at"
    t.text     "facebook_post_message"
    t.text     "facebook_post_caption"
    t.text     "facebook_post_description"
    t.integer  "total_levels_granted_by_non_author", default: 0
    t.boolean  "others_can_grant",                   default: false
    t.boolean  "is_system",                          default: false
    t.boolean  "is_approved",                        default: false
  end

  add_index "achievements", ["created_at"], name: "index_achievements_on_created_at", using: :btree
  add_index "achievements", ["total_levels_granted_by_non_author"], name: "index_achievements_on_total_levels_granted_by_non_author", using: :btree
  add_index "achievements", ["updated_at"], name: "index_achievements_on_updated_at", using: :btree
  add_index "achievements", ["user_id"], name: "index_achievements_on_user_id", using: :btree

  create_table "activities", force: true do |t|
    t.integer  "user_id"
    t.string   "action",     limit: 50
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at"
  end

  add_index "activities", ["created_at"], name: "index_activities_on_created_at", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "addresses", force: true do |t|
    t.integer  "user_id"
    t.string   "line_one"
    t.string   "line_two"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country"
    t.boolean  "is_shipping", default: false
    t.boolean  "is_billing",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ads", force: true do |t|
    t.string   "name"
    t.text     "html"
    t.integer  "frequency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "location"
    t.boolean  "published",        default: false
    t.boolean  "time_constrained", default: false
    t.string   "audience",         default: "all"
  end

  create_table "albums", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "view_count"
  end

  add_index "albums", ["user_id"], name: "index_albums_on_user_id", using: :btree

  create_table "assets", force: true do |t|
    t.string   "filename"
    t.integer  "width"
    t.integer  "height"
    t.string   "content_type"
    t.integer  "size"
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "thumbnail"
    t.integer  "parent_id"
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
  end

  create_table "authorizations", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "nickname"
    t.string   "email"
    t.string   "picture_url"
    t.string   "access_token"
    t.string   "access_token_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id", using: :btree

  create_table "avatars", force: true do |t|
    t.string   "name"
    t.integer  "achievement_id"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "badges", force: true do |t|
    t.string   "name"
    t.integer  "achievement_id"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "beta_invites", force: true do |t|
    t.string   "code"
    t.integer  "slots"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "slots_used",   default: 0
    t.string   "email"
    t.string   "invitee_name"
    t.string   "inviter_name"
    t.boolean  "publisher",    default: false
  end

  create_table "beta_requests", force: true do |t|
    t.string   "email"
    t.string   "notes"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "c_armors", force: true do |t|
    t.string   "name"
    t.string   "rating"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
  end

  add_index "c_armors", ["character_id"], name: "index_c_armors_on_character_id", using: :btree

  create_table "c_attributes", force: true do |t|
    t.string   "name"
    t.string   "score"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
    t.string   "modifiers"
  end

  add_index "c_attributes", ["character_id"], name: "index_c_attributes_on_character_id", using: :btree

  create_table "c_carried_items", force: true do |t|
    t.string   "name"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "c_carried_items", ["character_id"], name: "index_c_carried_items_on_character_id", using: :btree

  create_table "c_combats", force: true do |t|
    t.string   "name"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
  end

  add_index "c_combats", ["character_id"], name: "index_c_combats_on_character_id", using: :btree

  create_table "c_damages", force: true do |t|
    t.string   "name"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
  end

  add_index "c_damages", ["character_id"], name: "index_c_damages_on_character_id", using: :btree

  create_table "c_defenses", force: true do |t|
    t.string   "name"
    t.string   "rating"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
    t.string   "penalties"
    t.string   "special_properties"
    t.string   "dtype"
    t.string   "bonus"
  end

  add_index "c_defenses", ["character_id"], name: "index_c_defenses_on_character_id", using: :btree

  create_table "c_distinguishing_features", force: true do |t|
    t.string   "name"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "c_distinguishing_features", ["character_id"], name: "index_c_distinguishing_features_on_character_id", using: :btree

  create_table "c_educations", force: true do |t|
    t.string   "name"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "c_educations", ["character_id"], name: "index_c_educations_on_character_id", using: :btree

  create_table "c_flaws", force: true do |t|
    t.string   "name"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "c_flaws", ["character_id"], name: "index_c_flaws_on_character_id", using: :btree

  create_table "c_goals", force: true do |t|
    t.string   "name"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "c_goals", ["character_id"], name: "index_c_goals_on_character_id", using: :btree

  create_table "c_healings", force: true do |t|
    t.string   "name"
    t.string   "rating"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
  end

  add_index "c_healings", ["character_id"], name: "index_c_healings_on_character_id", using: :btree

  create_table "c_hobbies", force: true do |t|
    t.string   "name"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "c_hobbies", ["character_id"], name: "index_c_hobbies_on_character_id", using: :btree

  create_table "c_interests", force: true do |t|
    t.string   "name"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "c_interests", ["character_id"], name: "index_c_interests_on_character_id", using: :btree

  create_table "c_languages", force: true do |t|
    t.string   "name"
    t.string   "level"
    t.string   "base_attribute"
    t.string   "bonus"
    t.string   "penalty"
    t.string   "misc"
    t.string   "notes"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "c_languages", ["character_id"], name: "index_c_languages_on_character_id", using: :btree

  create_table "c_mannerisms", force: true do |t|
    t.string   "name"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "c_mannerisms", ["character_id"], name: "index_c_mannerisms_on_character_id", using: :btree

  create_table "c_maxwounds", force: true do |t|
    t.string   "score"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
  end

  add_index "c_maxwounds", ["character_id"], name: "index_c_maxwounds_on_character_id", using: :btree

  create_table "c_movements", force: true do |t|
    t.string   "name"
    t.string   "rate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
  end

  add_index "c_movements", ["character_id"], name: "index_c_movements_on_character_id", using: :btree

  create_table "c_physical_abilities", force: true do |t|
    t.string   "name"
    t.string   "notes"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "c_physical_abilities", ["character_id"], name: "index_c_physical_abilities_on_character_id", using: :btree

  create_table "c_possessions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
  end

  add_index "c_possessions", ["character_id"], name: "index_c_possessions_on_character_id", using: :btree

  create_table "c_powers", force: true do |t|
    t.string   "name"
    t.string   "requirements"
    t.string   "effects"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
    t.string   "duration"
    t.string   "range"
    t.string   "uses"
    t.string   "damage"
  end

  add_index "c_powers", ["character_id"], name: "index_c_powers_on_character_id", using: :btree

  create_table "c_previous_classes", force: true do |t|
    t.string   "name"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "c_previous_classes", ["character_id"], name: "index_c_previous_classes_on_character_id", using: :btree

  create_table "c_previous_professions", force: true do |t|
    t.string   "name"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "c_previous_professions", ["character_id"], name: "index_c_previous_professions_on_character_id", using: :btree

  create_table "c_qualities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
    t.string   "effects"
    t.string   "notes"
    t.string   "qtype"
  end

  add_index "c_qualities", ["character_id"], name: "index_c_qualities_on_character_id", using: :btree

  create_table "c_racial_abilities", force: true do |t|
    t.string   "name"
    t.string   "effects"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
  end

  add_index "c_racial_abilities", ["character_id"], name: "index_c_racial_abilities_on_character_id", using: :btree

  create_table "c_senses", force: true do |t|
    t.string   "name"
    t.string   "effect"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
  end

  add_index "c_senses", ["character_id"], name: "index_c_senses_on_character_id", using: :btree

  create_table "c_skill_specializations", force: true do |t|
    t.string   "name"
    t.string   "skill"
    t.string   "level"
    t.string   "bonus"
    t.string   "penalty"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
  end

  add_index "c_skill_specializations", ["character_id"], name: "index_c_skill_specializations_on_character_id", using: :btree

  create_table "c_skills", force: true do |t|
    t.string   "name"
    t.string   "base_attribute"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
    t.string   "level"
    t.string   "bonus"
    t.string   "penalty"
    t.string   "misc"
  end

  add_index "c_skills", ["character_id"], name: "index_c_skills_on_character_id", using: :btree

  create_table "c_special_abilities", force: true do |t|
    t.string   "name"
    t.string   "effects"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
    t.string   "notes"
  end

  add_index "c_special_abilities", ["character_id"], name: "index_c_special_abilities_on_character_id", using: :btree

  create_table "c_special_attributes", force: true do |t|
    t.string   "name"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
    t.string   "level"
    t.string   "effects"
  end

  add_index "c_special_attributes", ["character_id"], name: "index_c_special_attributes_on_character_id", using: :btree

  create_table "c_special_items", force: true do |t|
    t.string   "name"
    t.string   "effects"
    t.string   "uses"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "c_special_items", ["character_id"], name: "index_c_special_items_on_character_id", using: :btree

  create_table "c_trainings", force: true do |t|
    t.string   "name"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "c_trainings", ["character_id"], name: "index_c_trainings_on_character_id", using: :btree

  create_table "c_virtues", force: true do |t|
    t.string   "name"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "c_virtues", ["character_id"], name: "index_c_virtues_on_character_id", using: :btree

  create_table "c_wealths", force: true do |t|
    t.string   "name"
    t.string   "value"
    t.string   "amount"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "c_wealths", ["character_id"], name: "index_c_wealths_on_character_id", using: :btree

  create_table "c_weapons", force: true do |t|
    t.string   "name"
    t.string   "damage"
    t.string   "range"
    t.string   "capacity"
    t.string   "rate_of_fire"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
    t.string   "effects"
    t.string   "properties"
    t.string   "modifiers"
  end

  add_index "c_weapons", ["character_id"], name: "index_c_weapons_on_character_id", using: :btree

  create_table "c_wound_levels", force: true do |t|
    t.string   "level"
    t.string   "rating"
    t.string   "cur_damage"
    t.string   "penalties"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_id"
  end

  add_index "c_wound_levels", ["character_id"], name: "index_c_wound_levels_on_character_id", using: :btree

  create_table "categories", force: true do |t|
    t.string "name"
    t.text   "tips"
    t.string "new_post_text"
    t.string "nav_text"
    t.string "slug"
  end

  add_index "categories", ["slug"], name: "index_categories_on_slug", unique: true, using: :btree

  create_table "character_products", force: true do |t|
    t.integer  "character_id", null: false
    t.integer  "product_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "character_products", ["character_id"], name: "index_character_products_on_character_id", using: :btree
  add_index "character_products", ["product_id"], name: "index_character_products_on_product_id", using: :btree

  create_table "character_registrations", force: true do |t|
    t.integer  "game_id"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.integer  "player_registration_id"
  end

  add_index "character_registrations", ["character_id"], name: "index_registrations_on_character_id", using: :btree
  add_index "character_registrations", ["game_id"], name: "index_registrations_on_game_id", using: :btree
  add_index "character_registrations", ["player_registration_id"], name: "index_character_registrations_on_player_registration_id", using: :btree
  add_index "character_registrations", ["status"], name: "index_registrations_on_status", using: :btree

  create_table "characters", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.string   "property",                          default: ""
    t.string   "genre",                             default: ""
    t.text     "about"
    t.text     "background"
    t.text     "party_description"
    t.string   "gender",                            default: ""
    t.string   "race"
    t.string   "eye_color"
    t.string   "hair_color"
    t.string   "fashion_sense"
    t.string   "place_of_birth"
    t.string   "current_residence"
    t.string   "relationship_status"
    t.string   "weapon_of_choice"
    t.string   "ethnicity"
    t.string   "birthday"
    t.string   "astrological_sign"
    t.string   "age"
    t.string   "skin_color"
    t.string   "height"
    t.string   "weight"
    t.string   "level"
    t.string   "guild",                             default: ""
    t.string   "server",                            default: ""
    t.string   "current_profession"
    t.string   "current_class"
    t.string   "paragon_path"
    t.string   "epic_destiny"
    t.string   "xp_name",                           default: "XP"
    t.string   "xp_earned",                         default: "0"
    t.string   "xp_spent",                          default: "0"
    t.integer  "view_count",                        default: 0
    t.integer  "avatar_id"
    t.text     "character_relationships"
    t.string   "alignment"
    t.string   "xp_unspent",                        default: "0"
    t.text     "owner_notepad"
    t.text     "public_notepad"
    t.integer  "pregenerated_character_request_id"
    t.boolean  "others_can_clone",                  default: false
    t.boolean  "is_private",                        default: false
    t.string   "name_slug"
    t.integer  "products_counter",                  default: 0
  end

  add_index "characters", ["avatar_id"], name: "index_characters_on_avatar_id", using: :btree
  add_index "characters", ["created_at"], name: "index_characters_on_created_at", using: :btree
  add_index "characters", ["genre"], name: "index_characters_on_genre", using: :btree
  add_index "characters", ["is_private"], name: "index_characters_on_is_private", using: :btree
  add_index "characters", ["name"], name: "index_characters_on_name", using: :btree
  add_index "characters", ["name_slug"], name: "index_characters_on_name_slug", using: :btree
  add_index "characters", ["property"], name: "index_characters_on_property", using: :btree
  add_index "characters", ["updated_at"], name: "index_characters_on_updated_at", using: :btree
  add_index "characters", ["user_id"], name: "index_characters_on_user_id", using: :btree
  add_index "characters", ["view_count"], name: "index_characters_on_view_count", using: :btree

  create_table "choices", force: true do |t|
    t.integer "poll_id"
    t.string  "description"
    t.integer "votes_count", default: 0
  end

  create_table "clippings", force: true do |t|
    t.string   "url"
    t.integer  "user_id"
    t.string   "image_url"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "favorited_count", default: 0
  end

  add_index "clippings", ["created_at"], name: "index_clippings_on_created_at", using: :btree
  add_index "clippings", ["user_id"], name: "index_clippings_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.datetime "created_at",                                       null: false
    t.integer  "commentable_id",              default: 0,          null: false
    t.string   "commentable_type", limit: 15, default: "",         null: false
    t.integer  "user_id",                     default: 0,          null: false
    t.integer  "recipient_id"
    t.string   "author_name"
    t.string   "author_email"
    t.string   "author_url"
    t.string   "author_ip"
    t.boolean  "notify_by_email",             default: true
    t.string   "title",            limit: 50, default: ""
    t.text     "comment"
    t.string   "role",                        default: "comments"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["created_at"], name: "index_comments_on_created_at", using: :btree
  add_index "comments", ["recipient_id"], name: "index_comments_on_recipient_id", using: :btree
  add_index "comments", ["user_id"], name: "fk_comments_user", using: :btree

  create_table "contests", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "begin_date"
    t.datetime "end_date"
    t.text     "raw_post"
    t.text     "post"
    t.string   "banner_title"
    t.string   "banner_subtitle"
  end

  add_index "contests", ["begin_date"], name: "index_contests_on_begin_date", using: :btree
  add_index "contests", ["created_at"], name: "index_contests_on_created_at", using: :btree
  add_index "contests", ["end_date"], name: "index_contests_on_end_date", using: :btree

  create_table "countries", force: true do |t|
    t.string "name"
  end

  create_table "events", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "description"
    t.integer  "metro_area_id"
    t.string   "location"
    t.boolean  "allow_rsvp",                           default: true
    t.text     "summary"
    t.integer  "avatar_id"
    t.integer  "view_count",                           default: 0
    t.boolean  "is_registering_games",                 default: false
    t.boolean  "is_registering_regular_players",       default: false
    t.boolean  "is_registering_premium_players",       default: false
    t.boolean  "show_game_reg_links_on_event_profile", default: true
    t.boolean  "is_primary_home_page_promo",           default: false
    t.boolean  "is_secondary_home_page_promo",         default: false
  end

  add_index "events", ["is_primary_home_page_promo"], name: "index_events_on_is_primary_home_page_promo", using: :btree
  add_index "events", ["is_secondary_home_page_promo"], name: "index_events_on_is_secondary_home_page_promo", using: :btree
  add_index "events", ["show_game_reg_links_on_event_profile"], name: "index_events_on_show_game_reg_links_on_event_profile", using: :btree
  add_index "events", ["updated_at"], name: "index_events_on_updated_at", using: :btree

  create_table "facebook_templates", force: true do |t|
    t.string "template_name", null: false
    t.string "content_hash",  null: false
    t.string "bundle_id"
  end

  add_index "facebook_templates", ["template_name"], name: "index_facebook_templates_on_template_name", unique: true, using: :btree

  create_table "favorites", force: true do |t|
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "favoritable_type"
    t.integer  "favoritable_id"
    t.integer  "user_id"
    t.string   "ip_address",       default: ""
  end

  add_index "favorites", ["user_id"], name: "fk_favorites_user", using: :btree

  create_table "forums", force: true do |t|
    t.string  "name"
    t.string  "description"
    t.integer "topics_count",     default: 0
    t.integer "sb_posts_count",   default: 0
    t.integer "position"
    t.text    "description_html"
    t.string  "owner_type"
    t.integer "owner_id"
  end

  add_index "forums", ["position"], name: "index_forums_on_position", using: :btree

  create_table "friendship_statuses", force: true do |t|
    t.string "name"
  end

  create_table "friendships", force: true do |t|
    t.integer  "friend_id"
    t.integer  "user_id"
    t.boolean  "initiator",            default: false
    t.datetime "created_at"
    t.integer  "friendship_status_id"
  end

  add_index "friendships", ["friendship_status_id"], name: "index_friendships_on_friendship_status_id", using: :btree
  add_index "friendships", ["user_id"], name: "index_friendships_on_user_id", using: :btree

  create_table "game_products", force: true do |t|
    t.integer  "game_id",    null: false
    t.integer  "product_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_products", ["game_id"], name: "index_game_products_on_game_id", using: :btree
  add_index "game_products", ["product_id"], name: "index_game_products_on_product_id", using: :btree

  create_table "game_systems", force: true do |t|
    t.string   "name"
    t.integer  "open_game_count",  default: 0
    t.integer  "total_game_count", default: 0
    t.boolean  "format_approved",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_systems", ["name"], name: "index_game_systems_on_name", using: :btree

  create_table "games", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.text     "description"
    t.string   "genre",                             default: ""
    t.string   "system_deprecated",                 default: ""
    t.text     "premise"
    t.text     "style_of_play"
    t.integer  "player_seats",                      default: 3
    t.string   "next_game_time",                    default: ""
    t.integer  "view_count",                        default: 0
    t.integer  "avatar_id"
    t.string   "session_length",                    default: ""
    t.integer  "min_age",                           default: 13
    t.integer  "max_age",                           default: 100
    t.text     "owner_notepad"
    t.text     "group_notepad"
    t.text     "public_notepad"
    t.string   "number_of_sessions"
    t.boolean  "allow_spectators",                  default: false
    t.integer  "room_id"
    t.integer  "d20pro_port",                       default: 10101
    t.boolean  "is_d20pro",                         default: false
    t.text     "d20pro_ip"
    t.text     "d20pro_password"
    t.boolean  "d20pro_ready_to_play",              default: false
    t.integer  "game_system_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean  "auto_approve_player_registrations", default: true
    t.integer  "alternate_seats",                   default: 0
    t.boolean  "others_can_clone",                  default: false
    t.string   "opentok_session_id"
    t.boolean  "is_private",                        default: false
    t.boolean  "use_video",                         default: true
    t.string   "name_slug"
    t.integer  "products_counter",                  default: 0
  end

  add_index "games", ["avatar_id"], name: "index_games_on_avatar_id", using: :btree
  add_index "games", ["created_at"], name: "index_games_on_created_at", using: :btree
  add_index "games", ["end_at"], name: "index_games_on_end_at", using: :btree
  add_index "games", ["genre"], name: "index_games_on_genre", using: :btree
  add_index "games", ["is_private"], name: "index_games_on_is_private", using: :btree
  add_index "games", ["name"], name: "index_games_on_name", using: :btree
  add_index "games", ["name_slug"], name: "index_games_on_name_slug", using: :btree
  add_index "games", ["start_at"], name: "index_games_on_start_at", using: :btree
  add_index "games", ["status"], name: "index_games_on_status", using: :btree
  add_index "games", ["system_deprecated"], name: "index_games_on_system", using: :btree
  add_index "games", ["updated_at"], name: "index_games_on_updated_at", using: :btree
  add_index "games", ["user_id"], name: "index_games_on_user_id", using: :btree
  add_index "games", ["view_count"], name: "index_games_on_view_count", using: :btree

  create_table "homepage_features", force: true do |t|
    t.datetime "created_at"
    t.string   "url"
    t.string   "title"
    t.text     "description"
    t.datetime "updated_at"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "intake_surveys", force: true do |t|
    t.string   "login"
    t.integer  "q1"
    t.integer  "q2"
    t.string   "q3"
    t.integer  "q4"
    t.integer  "q5"
    t.integer  "q6"
    t.integer  "q7"
    t.integer  "q8"
    t.integer  "q9"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", force: true do |t|
    t.string   "email_addresses"
    t.string   "message"
    t.integer  "user_id"
    t.datetime "created_at"
  end

  add_index "invitations", ["email_addresses"], name: "index_invitations_on_email_addresses", using: :btree
  add_index "invitations", ["user_id"], name: "index_invitations_on_user_id", using: :btree

  create_table "ipn_invoice_notifications", force: true do |t|
    t.text     "params"
    t.integer  "user_id"
    t.string   "payment_status"
    t.string   "ipn_track_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "item_name"
    t.string   "txn_type"
    t.decimal  "payment_gross",  precision: 8, scale: 2, default: 0.0
    t.string   "payer_email"
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "ipn_subscription_notifications", force: true do |t|
    t.text     "params"
    t.integer  "user_id"
    t.string   "txn_type"
    t.string   "subscr_id"
    t.string   "ipn_track_id"
    t.decimal  "payment_gross", precision: 8, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "payer_email"
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "members", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_threads", force: true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "message_id"
    t.integer  "parent_message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_threads", ["recipient_id"], name: "index_message_threads_on_recipient_id", using: :btree

  create_table "messages", force: true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "sender_deleted",    default: false
    t.boolean  "recipient_deleted", default: false
    t.string   "subject"
    t.text     "body"
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
  end

  add_index "messages", ["parent_id"], name: "index_messages_on_parent_id", using: :btree
  add_index "messages", ["recipient_deleted", "recipient_id", "read_at"], name: "index_messages_on_recipient_deleted_and_recipient_id_and_read_at", using: :btree

  create_table "metro_areas", force: true do |t|
    t.string  "name"
    t.integer "state_id"
    t.integer "country_id"
    t.integer "users_count", default: 0
  end

  add_index "metro_areas", ["state_id"], name: "index_metro_areas_on_state_id", using: :btree
  add_index "metro_areas", ["users_count"], name: "index_metro_areas_on_users_count", using: :btree

  create_table "moderatorships", force: true do |t|
    t.integer "forum_id"
    t.integer "user_id"
  end

  add_index "moderatorships", ["forum_id"], name: "index_moderatorships_on_forum_id", using: :btree

  create_table "monitorships", force: true do |t|
    t.integer "topic_id"
    t.integer "user_id"
    t.boolean "active",   default: true
  end

  add_index "monitorships", ["active"], name: "index_monitorships_on_active", using: :btree

  create_table "offerings", force: true do |t|
    t.integer "skill_id"
    t.integer "user_id"
  end

  add_index "offerings", ["user_id"], name: "index_offerings_on_user_id", using: :btree

  create_table "pages", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "published_as", limit: 16, default: "draft"
    t.boolean  "page_public",             default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.integer  "album_id"
    t.integer  "view_count"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "is_private",         default: false
  end

  add_index "photos", ["created_at"], name: "index_photos_on_created_at", using: :btree
  add_index "photos", ["is_private"], name: "index_photos_on_is_private", using: :btree
  add_index "photos", ["parent_id"], name: "index_photos_on_parent_id", using: :btree
  add_index "photos", ["user_id"], name: "index_photos_on_user_id", using: :btree

  create_table "player_registrations", force: true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "player_registrations", ["game_id"], name: "index_player_registrations_on_game_id", using: :btree
  add_index "player_registrations", ["status"], name: "index_player_registrations_on_status", using: :btree
  add_index "player_registrations", ["user_id"], name: "index_player_registrations_on_user_id", using: :btree

  create_table "plugin_schema_migrations", id: false, force: true do |t|
    t.string "plugin_name"
    t.string "version"
  end

  create_table "polls", force: true do |t|
    t.string   "question"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_id"
    t.integer  "votes_count", default: 0
  end

  add_index "polls", ["created_at"], name: "index_polls_on_created_at", using: :btree
  add_index "polls", ["post_id"], name: "index_polls_on_post_id", using: :btree

  create_table "posts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "raw_post"
    t.text     "post"
    t.string   "title"
    t.integer  "category_id"
    t.integer  "user_id"
    t.integer  "view_count",                            default: 0
    t.integer  "contest_id"
    t.integer  "emailed_count",                         default: 0
    t.integer  "favorited_count",                       default: 0
    t.string   "published_as",               limit: 16, default: "draft"
    t.datetime "published_at"
    t.integer  "game_id"
    t.integer  "character_id"
    t.integer  "product_id"
    t.integer  "event_id"
    t.boolean  "send_comment_notifications",            default: true
    t.boolean  "is_system_announcement",                default: false
    t.boolean  "is_game_announcement",                  default: false
  end

  add_index "posts", ["category_id"], name: "index_posts_on_category_id", using: :btree
  add_index "posts", ["character_id"], name: "index_posts_on_character_id", using: :btree
  add_index "posts", ["event_id"], name: "index_posts_on_event_id", using: :btree
  add_index "posts", ["game_id"], name: "index_posts_on_game_id", using: :btree
  add_index "posts", ["product_id"], name: "index_posts_on_product_id", using: :btree
  add_index "posts", ["published_as"], name: "index_posts_on_published_as", using: :btree
  add_index "posts", ["published_at"], name: "index_posts_on_published_at", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "pregenerated_character_offers", force: true do |t|
    t.integer  "game_id"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pregenerated_character_offers", ["character_id"], name: "index_pregenerated_character_offers_on_character_id", using: :btree
  add_index "pregenerated_character_offers", ["game_id"], name: "index_pregenerated_character_offers_on_game_id", using: :btree

  create_table "pregenerated_character_requests", force: true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "character_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pregenerated_character_requests", ["character_id"], name: "index_pregenerated_character_requests_on_character_id", using: :btree
  add_index "pregenerated_character_requests", ["game_id"], name: "index_pregenerated_character_requests_on_game_id", using: :btree
  add_index "pregenerated_character_requests", ["user_id"], name: "index_pregenerated_character_requests_on_user_id", using: :btree

  create_table "products", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "view_count",              default: 0
    t.integer  "avatar_id"
    t.string   "manufacturer"
    t.string   "key_creatives"
    t.string   "product_code"
    t.string   "isbn"
    t.string   "price"
    t.string   "date_available"
    t.string   "purchase_book_url"
    t.string   "purchase_pdf_url"
    t.integer  "featured_product_rank"
    t.string   "free_stuff_url"
    t.text     "summary"
    t.integer  "catalog_rank"
    t.integer  "dtrpg_product_id"
    t.string   "dtrpg_product_image"
    t.string   "name_slug"
    t.text     "dtrpg_authors"
    t.text     "dtrpg_artists"
    t.string   "dtrpg_price"
    t.string   "dtrpg_sale_price"
    t.string   "dtrpg_pages"
    t.string   "dtrpg_file_size"
    t.string   "dtrpg_format"
    t.string   "dtrpg_file_information"
    t.string   "dtrpg_file_last_updated"
    t.boolean  "is_core_rulebook",        default: false
    t.string   "amazon_asin"
    t.string   "amazon_image_url"
    t.integer  "games_counter",           default: 0
    t.integer  "characters_counter",      default: 0
  end

  add_index "products", ["avatar_id"], name: "index_products_on_avatar_id", using: :btree
  add_index "products", ["catalog_rank"], name: "index_products_on_catalog_rank", using: :btree
  add_index "products", ["characters_counter"], name: "index_products_on_characters_counter", using: :btree
  add_index "products", ["created_at"], name: "index_products_on_created_at", using: :btree
  add_index "products", ["featured_product_rank"], name: "index_products_on_featured_product_rank", using: :btree
  add_index "products", ["games_counter"], name: "index_products_on_games_counter", using: :btree
  add_index "products", ["is_core_rulebook"], name: "index_products_on_is_core_rulebook", using: :btree
  add_index "products", ["name"], name: "index_products_on_name", using: :btree
  add_index "products", ["name_slug"], name: "index_products_on_name_slug", using: :btree
  add_index "products", ["updated_at"], name: "index_products_on_updated_at", using: :btree
  add_index "products", ["user_id"], name: "index_products_on_user_id", using: :btree
  add_index "products", ["view_count"], name: "index_products_on_view_count", using: :btree

  create_table "roles", force: true do |t|
    t.string "name"
  end

  create_table "rsvps", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "attendees_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sb_posts", force: true do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "forum_id"
    t.text     "body_html"
    t.string   "author_name"
    t.string   "author_email"
    t.string   "author_url"
    t.string   "author_ip"
  end

  add_index "sb_posts", ["created_at"], name: "index_sb_posts_on_created_at", using: :btree
  add_index "sb_posts", ["forum_id", "created_at"], name: "index_sb_posts_on_forum_id", using: :btree
  add_index "sb_posts", ["topic_id"], name: "index_sb_posts_on_topic_id", using: :btree
  add_index "sb_posts", ["user_id", "created_at"], name: "index_sb_posts_on_user_id", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "sessid"
    t.text     "data"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "sessions", ["sessid"], name: "index_sessions_on_sessid", using: :btree

  create_table "skills", force: true do |t|
    t.string "name"
  end

  create_table "slot_game_registrations", force: true do |t|
    t.integer  "slot_id"
    t.integer  "game_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "slot_game_registrations", ["game_id"], name: "index_slot_game_registrations_on_game_id", using: :btree

  create_table "slots", force: true do |t|
    t.integer  "event_id"
    t.string   "name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "slots", ["event_id"], name: "index_slots_on_event_id", using: :btree

  create_table "states", force: true do |t|
    t.string "name"
  end

  create_table "system_categories", force: true do |t|
    t.string   "name"
    t.string   "name_slug"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "avatar_id"
    t.integer  "view_count",               default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dtrpg_category_id"
    t.integer  "dtrpg_parent_category_id"
    t.string   "dtrpg_category_image"
    t.integer  "products_counter",         default: 0
    t.integer  "games_counter",            default: 0
    t.integer  "characters_counter",       default: 0
    t.integer  "popularity_score",         default: 0
  end

  add_index "system_categories", ["dtrpg_category_id"], name: "index_system_categories_on_dtrpg_category_id", using: :btree
  add_index "system_categories", ["dtrpg_parent_category_id"], name: "index_system_categories_on_dtrpg_parent_category_id", using: :btree

  create_table "system_category_products", force: true do |t|
    t.integer  "product_id"
    t.integer  "system_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type"], name: "index_taggings_on_taggable_id_and_taggable_type", using: :btree
  add_index "taggings", ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
  add_index "taggings", ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree

  create_table "thumbs", force: true do |t|
    t.string   "name"
    t.integer  "achievement_id"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", force: true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hits",           default: 0
    t.integer  "sticky",         default: 0
    t.integer  "sb_posts_count", default: 0
    t.datetime "replied_at"
    t.boolean  "locked",         default: false
    t.integer  "replied_by"
    t.integer  "last_post_id"
  end

  add_index "topics", ["forum_id", "replied_at"], name: "index_topics_on_forum_id_and_replied_at", using: :btree
  add_index "topics", ["forum_id", "sticky", "replied_at"], name: "index_topics_on_sticky_and_replied_at", using: :btree
  add_index "topics", ["forum_id"], name: "index_topics_on_forum_id", using: :btree
  add_index "topics", ["replied_at"], name: "index_topics_on_replied_at", using: :btree

  create_table "unlocked_achievements", force: true do |t|
    t.integer  "user_id"
    t.integer  "achievement_id"
    t.integer  "level",          default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
    t.integer  "character_id"
    t.boolean  "accepted",       default: false
    t.integer  "grantor_id"
  end

  add_index "unlocked_achievements", ["achievement_id"], name: "index_user_achievements_on_achievement_id", using: :btree
  add_index "unlocked_achievements", ["character_id", "accepted"], name: "index_unlocked_achievements_on_character_id_and_accepted", using: :btree
  add_index "unlocked_achievements", ["game_id", "accepted"], name: "index_unlocked_achievements_on_game_id_and_accepted", using: :btree
  add_index "unlocked_achievements", ["user_id", "accepted"], name: "index_unlocked_achievements_on_user_id_and_accepted", using: :btree
  add_index "unlocked_achievements", ["user_id", "achievement_id"], name: "index_user_achievements_on_user_id_and_achievement_id", using: :btree
  add_index "unlocked_achievements", ["user_id"], name: "index_user_achievements_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "email"
    t.text     "description"
    t.integer  "avatar_id"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "persistence_token"
    t.text     "stylesheet"
    t.integer  "view_count",                                        default: 0
    t.boolean  "vendor",                                            default: false
    t.string   "activation_code",                        limit: 40
    t.datetime "activated_at"
    t.integer  "state_id"
    t.integer  "metro_area_id"
    t.string   "login_slug"
    t.boolean  "notify_comments",                                   default: true
    t.boolean  "notify_friend_requests",                            default: true
    t.boolean  "notify_community_news",                             default: true
    t.integer  "country_id"
    t.boolean  "featured_writer",                                   default: false
    t.datetime "last_login_at"
    t.string   "zip"
    t.date     "birthday"
    t.string   "gender"
    t.boolean  "profile_public",                                    default: true
    t.integer  "activities_count",                                  default: 0
    t.integer  "sb_posts_count",                                    default: 0
    t.datetime "sb_last_seen_at"
    t.integer  "role_id"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",                                       default: 0
    t.integer  "failed_login_count",                                default: 0
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "notify_registrations",                              default: true
    t.string   "beta_invite_code"
    t.boolean  "notify_admin_blasts",                               default: true
    t.boolean  "notify_new_games",                                  default: true
    t.boolean  "publisher",                                         default: false
    t.string   "publisher_name"
    t.string   "summary"
    t.string   "free_stuff_url"
    t.string   "facebook_id"
    t.string   "session_key"
    t.string   "blog_rss_url",                                      default: ""
    t.integer  "dtrpg_id"
    t.boolean  "enable_network_god_mode",                           default: false
    t.string   "time_zone",                                         default: "Pacific Time (US & Canada)"
    t.boolean  "power_user",                                        default: false
    t.datetime "last_fb_autopost",                                  default: '2011-06-30 21:35:21'
    t.boolean  "allow_fb_autopost_new_friend",                      default: true
    t.boolean  "allow_fb_autopost_achievement_unlocked",            default: true
    t.boolean  "chat_admin",                                        default: false
    t.boolean  "posted_to_facebook_user_joined_infrno",             default: false
    t.boolean  "notify_upcoming_games",                             default: true
    t.boolean  "user_admin",                                        default: false
    t.string   "dtrpg_logo"
    t.boolean  "convention",                                        default: false
    t.boolean  "flgs",                                              default: false
    t.boolean  "event_admin",                                       default: false
    t.boolean  "is_premium",                                        default: false
    t.boolean  "achievement_admin",                                 default: false
    t.integer  "membership_level",                                  default: 0
    t.boolean  "posted_to_facebook_account_upgrade",                default: false
    t.boolean  "is_banned",                                         default: false
    t.string   "vendor_url"
    t.string   "tshirt_size"
    t.boolean  "epic_tshirt_shipped",                               default: false
    t.boolean  "exalted_tshirt_shipped",                            default: false
  end

  add_index "users", ["activated_at"], name: "index_users_on_activated_at", using: :btree
  add_index "users", ["activation_code"], name: "index_users_on_activation_code", using: :btree
  add_index "users", ["avatar_id"], name: "index_users_on_avatar_id", using: :btree
  add_index "users", ["created_at"], name: "index_users_on_created_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["event_admin"], name: "index_users_on_event_admin", using: :btree
  add_index "users", ["featured_writer"], name: "index_users_on_featured_writer", using: :btree
  add_index "users", ["last_request_at"], name: "index_users_on_last_request_at", using: :btree
  add_index "users", ["login"], name: "index_users_on_login", using: :btree
  add_index "users", ["login_slug"], name: "index_users_on_login_slug", using: :btree
  add_index "users", ["metro_area_id"], name: "index_users_on_metro_area_id", using: :btree
  add_index "users", ["persistence_token"], name: "index_users_on_persistence_token", using: :btree
  add_index "users", ["publisher"], name: "index_users_on_publisher", using: :btree
  add_index "users", ["sb_last_seen_at"], name: "index_users_on_sb_last_seen_at", using: :btree
  add_index "users", ["sb_posts_count"], name: "index_users_on_sb_posts_count", using: :btree
  add_index "users", ["single_access_token"], name: "index_users_on_single_access_token", using: :btree
  add_index "users", ["vendor"], name: "index_users_on_vendor", using: :btree

  create_table "votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "poll_id"
    t.integer  "choice_id"
    t.datetime "created_at"
  end

end
