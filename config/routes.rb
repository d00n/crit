Crit::Application.routes.draw do

  mount CommunityEngine::Engine => "/"

  #get  '/' => 'base#site_index', :as => :home

  resources :achievements
  resources :player_registrations
  resources :intake_survey
  resources :game_systems
  resources :properties
  resources :characters
  resources :games
  resources :events do
    resources :slots
  end
  resources :characters
  resources :products
  resources :system_categories

  post '/logout' => 'sessions#destroy', :as => :logout_button

  get  '/game_systems/:id/migrate/:system_category_id' => 'game_systems#migrate', :as => :game_system_migrate
  get  '/system_categories/search/:game_system_id' => 'system_categories#index', :as => :system_category_search
  get  '/system_categories/new_game' => 'system_categories#new_game', :as => :system_categories_new_game


  get  '/system_categories/:id/pick_profile_photo' => 'system_categories#pick_profile_photo', :as => :system_category_pick_profile_photo
  put  '/system_categories/:id/change_profile_photo' => 'system_categories#change_profile_photo', :as => :system_category_change_profile_photo
  get  '/system_categories/:id/bump_views' => 'system_categories#bump_views', :as => :system_category_bump_views
  get  '/system_categories/:id/product/search' => 'system_categories#product_search', :as => :system_category_product_search
  get  '/system_categories/:id/product/:product_id/add' => 'system_categories#product_add', :as => :system_category_product_add
  get  '/system_categories/:id/product/:product_id/remove' => 'system_categories#product_remove', :as => :system_category_product_remove
  get  '/system_categories/:id/game/:game_id/add' => 'system_categories#add_game', :as => :system_category_add_game
  get  '/system_categories/:id/character/:character_id/add' => 'system_categories#add_character', :as => :system_category_add_character
  get  '/products/:id/system_categories' => 'products#system_categories', :as => :product_system_categories

  post '/ipn_subscription_notifications' => 'ipn_subscription_notifications#create', :as => :ipn_subscription_notifications
  post '/ipn_invoice_notifications' => 'ipn_invoice_notifications#create', :as => :ipn_invoice_notifications

  get  '/membership/premium_plans' => 'memberships#premium_membership', :as => :premium_membership
  get  '/membership/mythic' => 'memberships#mythic', :as => :mythic
  get  '/membership/thank_you' => 'memberships#thank_you', :as => :membership_thank_you
  get  '/membership/discounts' => 'memberships#discounts', :as => :membership_discounts
  get  '/users/:id/membership' => 'users#membership', :as => :user_membership

  get  '/flgs' => 'base#flgs'

  get  '/users/:user_id/games/:id' => 'games#show', :as => :user_game
  get  '/users/:user_id/characters/:id' => 'characters#show', :as => :user_character
  get  '/users/:user_id/events/:id' => 'events#show', :as => :user_event



  get  '/newsletter_user_list.:format' => 'users#newsletter_user_list'
  get  '/newsletter_admin_list.:format' => 'users#newsletter_admin_list'
  get  '/newsletter_power_user_list.:format' => 'users#newsletter_power_user_list'
  get  '/newsletter_publisher_list.:format' => 'users#newsletter_publisher_list'


  put  '/users/:id/change_profile_photo' => 'users#change_profile_photo', :as => :user_change_profile_photo
  put  '/users/:id/update_views' => 'users#update_views', :as => :user_update_views
  get  '/users/:id/grant_network_god_mode_access' => 'users#grant_network_god_mode_access', :as => :grant_network_god_mode_access
  get  '/users/:id/revoke_network_god_mode_access' => 'users#revoke_network_god_mode_access', :as => :revoke_network_god_mode_access
  get  '/users/:id/grant_event_admin' => 'users#grant_event_admin', :as => :grant_event_admin
  get  '/users/:id/revoke_event_admin' => 'users#revoke_event_admin', :as => :revoke_event_admin
  get  '/users/:id/grant_chat_admin' => 'users#grant_chat_admin', :as => :grant_chat_admin
  get  '/users/:id/revoke_chat_admin' => 'users#revoke_chat_admin', :as => :revoke_chat_admin
  get  '/users/:id/grant_user_admin' => 'users#grant_user_admin', :as => :grant_user_admin
  get  '/users/:id/revoke_user_admin' => 'users#revoke_user_admin', :as => :revoke_user_admin
  get  '/users/:id/grant_achievement_admin' => 'users#grant_achievement_admin', :as => :grant_achievement_admin
  get  '/users/:id/revoke_achievement_admin' => 'users#revoke_achievement_admin', :as => :revoke_achievement_admin
  get  '/users/:id/ban_user' => 'users#ban_user', :as => :ban_user
  get  '/users/:id/unban_user' => 'users#unban_user', :as => :unban_user
  get  '/users/:id/address' => 'addresses#show', :as => :user_address
  get  '/users/:id/address/update' => 'addresses#update', :as => :update_user_address
  get  '/users/:id/tshirt_details' => 'users#tshirt_details', :as => :user_tshirt_details
  get  '/users/:id/tshirt_details/update' => 'users#update_tshirt_details', :as => :update_user_tshirt_details

  get  '/users/:id/grant_epic' => 'users#grant_epic', :as => :grant_epic
  get  '/users/:id/grant_legendary' => 'users#grant_legendary', :as => :grant_legendary
  get  '/users/:id/grant_exalted' => 'users#grant_exalted', :as => :grant_exalted
  get  '/users/:id/grant_mythic' => 'users#grant_mythic', :as => :grant_mythic
  get  '/users/:id/revoke_premium' => 'users#revoke_premium', :as => :revoke_premium

  get  '/games/:id/unlocked_achievements' => 'achievements#unlocked_game', :as => :unlocked_game_achievements
  get  '/characters/:id/unlocked_achievements' => 'achievements#unlocked_character', :as => :unlocked_character_achievements
  get  '/users/:id/unlocked_achievements' => 'achievements#unlocked_user', :as => :unlocked_user_achievements
  get  '/users/:id/authored_achievements' => 'achievements#authored', :as => :authored_achievements
  get  '/users/:id/achievements/manage' => 'achievements#manage', :as => :manage_achievements
  get  '/users/:id/achievements/select' => 'achievements#select_user', :as => :select_user_achievements
  get  '/games/:id/achievements/select' => 'achievements#select_game', :as => :select_game_achievements
  get  '/characters/:id/achievements/select' => 'achievements#select_character', :as => :select_character_achievements

  get  '/achievement/leaderboard/top_by_level' => 'achievements#leaderboard_top_by_level', :as => :achievement_leaderboard_top_by_level
  get  '/achievement/leaderboard/top_by_count' => 'achievements#leaderboard_top_by_count', :as => :achievement_leaderboard_top_by_count
  get  '/achievement/leaderboard/top_authors' => 'achievements#leaderboard_top_authors', :as => :achievement_leaderboard_top_authors
  get  '/achievements/:id/grant/:recipient_type/:recipient_id' => 'achievements#grant', :as => :grant_achievement
  get  '/achievements/:id/revoke/:ua_id' => 'achievements#revoke', :as => :revoke_achievement
  get  '/achievements/:id/remove/:ua_id' => 'achievements#remove', :as => :remove_achievement
  get  '/achievements/:id/accept/:ua_id' => 'achievements#accept', :as => :accept_achievement
  get  '/achievements/:id/deny/:ua_id' => 'achievements#deny', :as => :deny_achievement

  get  '/users/:id/calendar/:year/:month' => 'users#calendar', :year => Time.zone.now.year, :month => Time.zone.now.month, :as => :user_calendar
  get  '/users/:id/characters' => 'users#characters', :as => :user_characters
  get  '/users/:id/games' => 'users#games', :as => :user_games
  get  '/users/:id/games_playing' => 'users#games_playing', :as => :user_games_playing

  put  '/characters/:id/update_views' => 'characters#update_views', :as => :character_update_views
  get  '/characters/:id/pick_profile_photo' => 'characters#pick_profile_photo', :as => :character_pick_profile_photo
  put  '/characters/:id/change_profile_photo' => 'characters#change_profile_photo', :as => :character_change_profile_photo
  get  '/characters/:id/new_avatar_photo' => 'characters#new_avatar_photo', :as => :new_character_avatar_photo
  get  '/characters/:id/game_table_sheet' => 'characters#game_table_sheet', :as => :game_table_sheet
  get  '/characters/:id/edit_clone' => 'characters#edit_clone', :as => :edit_character_clone
  get  '/characters/:id/sheet' => 'characters#sheet', :as => :sheet
  get  '/characters/:id/print' => 'characters#print'
  get  '/characters/:id/posts' => 'posts#character_index', :as => :character_post
  get  '/characters/:id/notepad' => 'characters#notepad', :as => :character_notepad
  get  '/characters/:id/edit_notepad' => 'characters#edit_notepad', :as => :character_edit_notepad
  patch  '/characters/:id/update_notepad' => 'characters#update_notepad', :as => :character_update_notepad
  get  '/characters/auto_complete_for_character_genre' => 'characters#auto_complete_for_character_genre', :as => :auto_complete_for_character_genre

  get  '/characters/:id/products/' => 'characters#products', :as => :character_products
  #get  '/characters/:id/product/search' => 'characters#product_search', :as => :character_product_search
  get  '/characters/:id/product/:product_id/add' => 'characters#product_add', :as => :character_product_add
  get  '/characters/:id/product/:product_id/remove' => 'characters#product_remove', :as => :character_product_remove

  put  '/games/:id/update_views' => 'games#update_views', :as => :game_update_views
  put  '/games/:id/change_profile_photo' => 'games#change_profile_photo', :as => :game_change_profile_photo
  get  '/games/:id/register_player_for_event/slot/:slot_id' => 'games#register_player_for_event', :as => :register_player_for_event
  get  '/games/:id/register_alternate_for_event/slot/:slot_id' => 'games#register_alternate_for_event', :as => :register_alternate_for_event
  get  '/games/:id/d20pro_allow_connections' => 'games#d20pro_allow_connections', :as => :d20pro_allow_connections
  get  '/games/:id/d20pro_disable_connections' => 'games#d20pro_disable_connections', :as => :d20pro_disable_connections
  get  '/games/:id/d20pro_launch.:format' => 'games#d20pro_launch', :as => :d20pro_launch
  get  '/games/:id/pick_profile_photo' => 'games#pick_profile_photo', :as => :game_pick_profile_photo
  get  '/games/:id/registration_desk' => 'games#registration_desk', :as => :registration_desk
  get  '/games/:id/register_player/' => 'games#register_player', :as => :register_player
  get  '/games/:id/register_alternate/' => 'games#register_alternate', :as => :register_alternate
  get  '/games/:id/notepad' => 'games#notepad', :as => :game_notepad
  get  '/games/:id/edit_notepad' => 'games#edit_notepad', :as => :game_edit_notepad
  patch  '/games/:id/update_notepad' => 'games#update_notepad', :as => :game_update_notepad
  get  '/games/:id/posts' => 'posts#game_index', :as => :game_post
  get  '/games/:id/edit_pregenerated_character_offers' => 'games#edit_pregenerated_character_offers', :as => :edit_pregenerated_character_offers
  patch  '/games/:id/update_pregenerated_character_offers' => 'games#update_pregenerated_character_offers', :as => :update_pregenerated_character_offers
  get  '/games/:id/reset_game_table' => 'games#reset_game_table', :as => :reset_game_table
  get  '/games/:id/approve_player/:user_id' => 'games#approve_player', :as => :approve_player
  get  '/games/:id/deny_player/:user_id' => 'games#deny_player', :as => :deny_player
  get  '/games/:id/cancel_player/:user_id' => 'games#cancel_player', :as => :cancel_player
  get  '/games/:id/cancel_alternate/:user_id' => 'games#cancel_alternate', :as => :cancel_alternate
  get  '/games/:id/kick_character/:character_id' => 'games#kick_character', :as => :kick_character
  get  '/games/:id/kick_player/:user_id' => 'games#kick_player', :as => :kick_player
  get  '/games/:id/kick_alternate/:user_id' => 'games#kick_alternate', :as => :kick_alternate
  get  '/games/:id/release_alternates' => 'games#release_alternates', :as => :release_alternates
  get  '/games/:id/character_leave_game/:character_id' => 'games#character_leave_game', :as => :character_leave_game
  get  '/games/:id/player_leave_game/:user_id' => 'games#player_leave_game', :as => :player_leave_game
  get  '/games/:id/choose_pregenerated_character' => 'games#choose_pregenerated_character', :as => :choose_pregenerated_character
  get  '/games/:id/choose_character/' => 'games#choose_character', :as => :choose_character
  get  '/games/:id/register_new_character/' => 'games#register_new_character', :as => :register_new_character
  get  '/games/:id/register_pregenerated_character/:character_id' => 'games#register_pregenerated_character', :as => :register_pregenerated_character
  get  '/games/:id/register_character/:character_id' => 'games#register_character', :as => :register_character
  get  '/games/:id/edit_clone' => 'games#edit_clone', :as => :edit_game_clone
  get  '/games/:id/new_avatar_photo' => 'games#new_avatar_photo', :as => :new_game_avatar_photo
  get  '/games/:id/approve_player/:user_id' => "games#approve_player", :as => :game_approve_player
  get  '/games/:id/private/' => 'games#private_game', :as => :private_game

  get  '/publisher/:publisher_id/products/:product_id/games/:id/products/' => 'games#products', :as => :game_products
  #get  '/games/:id/product/search' => 'games#product_search', :as => :game_product_search
  get  '/games/:id/product/remove_all' => 'games#product_remove_all', :as => :game_product_remove_all
  get  '/games/:id/product/:product_id/add' => 'games#product_add', :as => :game_product_add
  get  '/games/:id/product/:product_id/remove' => 'games#product_remove', :as => :game_product_remove

  get  '/publishers/:publisher_id/products/' => 'products#index', :as => :publisher_products
  get  '/publishers/:publisher_id/products/:id/' => 'products#show', :as => :publisher_product
  get  '/publishers/:publisher_id/products/:product_id/games/:id/' => 'games#show', :as => :publisher_product_game
  get  '/publishers/:publisher_id/products/:product_id/characters/:id/' => 'characters#show', :as => :publisher_product_character
  get  '/publishers/:id/products/:product_id/games/' => 'products#games', :as => :product_games
  get  '/publishers/:id/products/:product_id/characters/' => 'products#characters', :as => :product_characters

  # Gotta handle games/chars with no products first
  #get  '/publishers/:id/products/:product_id/games/:game_id/' => 'games#show', :as => :game
  #get  '/publishers/:id/products/:product_id/characters/:character_id' => 'characters#show', :as => :character

  get  '/games/:id/play/' => 'games#play', :as => :gametable
  get  '/games/:id/gametable/' => 'games#gametable', :as => :whiteboard

#  get  '/game/open' => 'game_systems#index'
  get  '/admin/game_systems/:action' => 'game_systems#manage', :as => :admin_game_systems
  get  '/game_systems/search' => 'game_systems#search', :as => :game_system_search

  get  '/publishers' => 'users#index_publishers'
  get  '/publishers/:id/' => 'users#show', :as => :publisher
  get  '/new_publisher' => 'users#new_publisher'

  put  '/products/:id/update_views' => 'products#update_views', :as => :product_update_views
  put  '/products/:id/change_profile_photo' => 'products#change_profile_photo', :as => :product_change_profile_photo
  get  '/products/:id/pick_profile_photo' => 'products#pick_profile_photo', :as => :product_pick_profile_photo
  get  '/products/:id/remove_profile_photo' => 'products#remove_profile_photo', :as => :product_remove_profile_photo
#  get  '/products/user/:id/' => 'products#publisher_products', :as => :product_publisher_products
#  get  '/products/:user_id/manage_featured_products/' => 'products#manage_featured_products', :as => :product_manage_featured_products
#  get  '/products/:user_id/update_featured_products/' => 'products#update_featured_products', :as => :product_update_featured_products
#  get  '/products/:user_id/manage_catalog/' => 'products#manage_catalog', :as => :product_manage_catalog
#  get  '/products/:user_id/update_catalog/' => 'products#update_catalog', :as => :product_update_catalog

  get  '/auto_poster/pull_feeds' => 'auto_poster#pull_feeds'

  get  '/new_facebook' => 'users#new_facebook'

  put  '/events/:id/update_views' => 'events#update_views', :as => :event_update_views
  put  '/events/:id/change_profile_photo' => 'events#change_profile_photo', :as => :event_change_profile_photo
  get  '/events/:id/pick_profile_photo' => 'events#pick_profile_photo', :as => :event_pick_profile_photo
  get  '/events/:id/remove_profile_photo' => 'events#remove_profile_photo', :as => :event_remove_profile_photo
  get  '/events/:id/select_achievements' => 'events#select_achievements', :as => :select_event_achievements
  get  '/events/:id/grant_player_achievements/:achievement_id' => 'events#grant_player_achievements', :as => :grant_player_achievements
  get  '/events/:id/grant_gm_achievements/:achievement_id' => 'events#grant_gm_achievements', :as => :grant_gm_achievements
  get  '/event/:id/new_slot' => 'events#new_slot'
  get  '/event/:id/save_slot' => 'events#update_slot'
#  get  '/events/:id/open_game_registration_desks' => 'events#open_game_registration_desks', :as => :open_game_registration_desks
#  get  '/events/:id/close_game_registration_desks' => 'events#close_game_registration_desks', :as => :close_game_registration_desks
  get  '/events/:id/calendar/:year/:month' => 'events#calendar', :year => Time.zone.now.year, :month => Time.zone.now.month, :as => :event_calendar

  get  '/slots/:id/choose_game/' => 'slots#choose_game', :as => :choose_game
  get  '/slots/:id/register_new_game/' => 'slots#register_new_game', :as => :register_new_game
  get  '/slots/:id/register_game/:game_id' => 'slots#register_game', :as => :register_game
  get  '/slots/:id/approve_game/:game_id' => 'slots#approve_game', :as => :approve_game
  get  '/slots/:id/deny_game/:game_id' => 'slots#deny_game', :as => :deny_game
  get  '/slots/:id/kick_game/:game_id' => 'slots#kick_game', :as => :kick_game
  get  '/slots/:id/cancel_game/:game_id' => 'slots#cancel_game', :as => :cancel_game

  get  '/contact' => 'contact#index'
  post  '/contact_create' => 'contact#create'

  get  '/calendar/:year/:month' => 'calendar#index',
       :year => Time.zone.now.year,
       :month => Time.zone.now.month

  get  '/users/:id/calendar/ical.ics' => 'users#ical', :as => :user_ical

  scope "/:commentable_type/:commentable_id" do
    resources :comments, :as => :commentable_comments
  end

end
