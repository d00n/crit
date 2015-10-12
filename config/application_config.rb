configatron.configure_from_hash(

    :app_host => "www.infrno.net", #override this in your application.yml

    :community_name => "Infrno",

    :community_tagline => "Find. Connect. Play.",
    :community_description =>  "Infrno.net is facebook for role players, minus farmville, plus a virtual game table with video chat. All in your browser, and FREE!",
    :support_email =>  "support@infrno.net",
    :meta_description =>   'Infrno.net is facebook for role players, minus farmville, plus a virtual game table with video chat. All in your browser, and FREE!',
    :meta_keywords =>   'd and d online, d&d instruments, d&d 4ed, d&d domains, d&d languages, d&d faq, d&d alignments, d&d character ideas, d&d pax, d&d class, d&d 4th ed, d&d kord, d&d gazebo, d&d classes, d&d familiar, virtual table top, virtual tabletop, virtual game table, virtual gametable, online rpg free, d&d, free online multiplayer games, role playing games, role playing game, rpg',

    # Comment this out if you want to infer the locale
    # off of the http headers
    :community_locale => "en",

    :allow_anonymous_commenting => false,
    :allow_anonymous_forum_posting => false,
    :require_captcha_on_signup => false,

    :recaptcha_pub_key => '6LfSIMoSAAAAAECR7Fvr3RVGlcr97jfRKuFujZRL',
    :recaptcha_priv_key => '6LfSIMoSAAAAAF2aJIn63bJ0gL06H-Hlmjky1c49',

    #:akismet_key => YOUR_KEY,
    # uncomment this if you want to use akismet for comment filtering. Go to http://en.wordpress.com/api-keys/

    #uncomment below to use omniauth providers for login and signup
    # :auth_providers => {
    #   :twitter => {:key => 'key', :secret => 'secret'},
    #   :facebook => {:key => 'key', :secret => 'secret'}
    #   },
    #:auth_providers => {
    #    :facebook => {:key => '143701092336577', :secret => 'b2a1b5a50ff3ffba6f0a7d72e36a9a1a', :scope => "email, user_birthday, user_website, user_likes, user_hometown, user_interests, user_location, publish_stream, offline_access"}
    #},

    :ISBNDB_KEY => "S52FBNXY",
    :ONE_COL_INPUT_WIDTH => 40,
    :TWO_COL_INPUT_WIDTH => 30,
    :INFRNO_CSS_VERSION => 49,
    :OPENTOK_CSS_VERSION => 9,
    :EPIC_MONTHLY_DESCRIPTION => "Epic Monthly Subscription",
    :EPIC_SEMIANNUAL_DESCRIPTION => "Epic Semiannual Subscription",
    :EPIC_ANNUAL_DESCRIPTION => "Epic Annual Subscription",
    :EPIC_MONTHLY_AMOUNT => "4.99",
    :EPIC_SEMIANNUAL_AMOUNT => "26.95",
    :EPIC_ANNUAL_AMOUNT => "47.90",
    :LEGENDARY_MONTHLY_DESCRIPTION => "Legendary Monthly Subscription",
    :LEGENDARY_SEMIANNUAL_DESCRIPTION => "Legendary Semiannual Subscription",
    :LEGENDARY_ANNUAL_DESCRIPTION => "Legendary Annual Subscription",
    :LEGENDARY_MONTHLY_AMOUNT => "9.99",
    :LEGENDARY_SEMIANNUAL_AMOUNT => "53.95",
    :LEGENDARY_ANNUAL_AMOUNT => "95.90",
    :EXALTED_MONTHLY_DESCRIPTION => "Exalted Monthly Subscription",
    :EXALTED_SEMIANNUAL_DESCRIPTION => "Exalted Semiannual Subscription",
    :EXALTED_ANNUAL_DESCRIPTION => "Exalted Annual Subscription",
    :EXALTED_MONTHLY_AMOUNT => "14.99",
    :EXALTED_SEMIANNUAL_AMOUNT => "80.95",
    :EXALTED_ANNUAL_AMOUNT => "143.90",
    :EXALTED_LIFETIME_DESCRIPTION => "Exalted Lifetime Subscription",
    :EXALTED_LIFETIME_AMOUNT => "199.99",
    :DTRPG_HOST => 'http://rpg.drivethrustuff.com/',
    :DTRPG_IMAGE => 'http://rpg.drivethrustuff.com/images/',
    :DTRPG_PUBLISHER_URL => "http://rpg.drivethrustuff.com/index.php?manufacturers_id=",
    :DTRPG_INFRNO_AFFILIATE_CODE => 'affiliate_id=310477',
    :DTRPG_PRODUCT_URL => 'http://rpg.drivethrustuff.com/product/',
    :DTRPG_AUTHOR_URL => 'http://rpg.drivethrustuff.com/index.php?x=0&y=0&artist=',
    :DTRPG_ARTIST_URL => 'http://rpg.drivethrustuff.com/index.php?x=0&y=0&artist=',

    # for SEO reasons sometimes you should control the robots on how they have to handle your content
    # listing of stuff which points to single posts or entries should normally not been indexed,
    # but the robot should follow the internal link to show the post
    :robots_meta_list_content => 'noindex,follow',
    # the post itself should be indexed;
    # when links are included and they point to external sites, the robot should not follow
    :robots_meta_show_content => 'index,nofollow',

    # min and max age for users to use the site
    :min_age => 13,
    :max_age => 90,

    :authlogic => {
        :password_length => 6..20,
        :login_length => 5..100,
        :email_length => 3..100,
        :email_case_sensitive => true
    },

    :regexes => {
        :login => /\A[\sA-Za-z0-9_-]+\z/,
        :email => /\A([^@\s]+)@((?:[-a-z0-9A-Z]+\.)+[a-zA-Z]{2,})\z/
    },

    :photo => {
        :missing_thumb => 'bug_100.png',
        :missing_medium => "bug_290.png",
        :paperclip_options => {
            :default_url => "",
            :path => "#{Rails.root}/public/system/:attachment/:id/:style/:filename",
            :url => "/system/:attachment/:id/:style/:filename",
            :styles => {
                :thumb => {
                    :geometry => "100x100#",
                    :processors => [:cropper]
                },
                :medium => "290x320#",
                :large => "465>"
            }
        },
        :validation_options => {
            :max_size => 3,
            :content_type => ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png']
        }
    },

    :feature => {
        :use_thumbs => true,
        :dimensions => [150, 635],
        :paperclip_options => {
            :default_url => "",
            :path => "#{Rails.root}/public/system/:attachment/:id/:style/:filename",
            :url => "/system/:attachment/:id/:style/:filename",
            :styles => {
                :original => '465>',
                :thumb => "45x45#",
                :large => "635x150#"
            }
        },
        :validation_options => {
            :max_size => 3,
            :content_type => ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png']
        }
    },

    :clipping => {
        :paperclip_options => {
            :default_url => "",
            :path => "#{Rails.root}/public/system/:attachment/:id/:style/:filename",
            :url => "/system/:attachment/:id/:style/:filename",
            :styles => {
                :thumb => "100x100#",
                :medium => "290x320#",
                :large => "465>"
            }
        },
        :validation_options => {
            :max_size => 3,
            :content_type => ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png']
        }
    },

    :avatar => {
        :missing_thumb => '/assets/bug_100.png',
        :missing_medium => "/assets/bug_290.png",
        :paperclip_options => {
            :default_url => "",
            :path => "#{Rails.root}/public/system/:attachment/:id/:style/:filename",
            :url => "/system/:attachment/:id/:style/:filename",
            :styles => {
                :large => "290x320#"
            }
        },
        :validation_options => {
            :max_size => 3,
            :content_type => ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png']
        }
    },

    :badge => {
        :missing_thumb => '/assets/bug_100.png',
        :missing_medium => "/assets/bug_290.png",
        :paperclip_options => {
            :default_url => "",
            :path => "#{Rails.root}/public/system/:attachment/:id/:style/:filename",
            :url => "/system/:attachment/:id/:style/:filename",
            :styles => {
                :large => "50x50#"
            }
        },
        :validation_options => {
            :max_size => 3,
            :content_type => ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png']
        }
    },

    :thumb => {
        :missing_thumb => '/assets/bug_100.png',
        :missing_medium => "/assets/bug_290.png",
        :paperclip_options => {
            :default_url => "",
            :path => "#{Rails.root}/public/system/:attachment/:id/:style/:filename",
            :url => "/system/:attachment/:id/:style/:filename",
            :styles => {
                :large => "90x90#"
            }
        },
        :validation_options => {
            :max_size => 3,
            :content_type => ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png']
        }
    },

    :reserved_logins => [
        'achievement',
        'achievements',
        'about',
        'account',
        'advertise',
        'ads',
        'application',
        'assets',
        'categories',
        'character',
        'characters',
        'choices',
        'clippings',
        'clipping_images',
        'comments',
        'contact',
        'contests',
        'countries',
        'css_help',
        'events',
        'favorites',
        'faq',
        'featured',
        'forum',
        'forums',
        'friendships',
        'friendship_statuses',
        'game',
        'games',
        'game_system',
        'game_systems',
        'home',
        'homes',
        'homepage_features',
        'image',
        'images',
        'infrnal',
        'infrno',
        'invitation',
        'invitations',
        'javascript',
        'javascripts',
        'login',
        'logins',
        'logout',
        'manage_photo',
        'manage_photos',
        'message',
        'messages',
        'metro_areas',
        'moderatorships',
        'new_clipping',
        'offerings',
        'photo',
        'photos',
        'polls',
        'popular',
        'popular_rss',
        'post',
        'posts',
        'product',
        'products',
        'publisher',
        'publishers',
        'recent',
        'roles',
        'search',
        'signup',
        'sb_post',
        'sb_posts',
        'skill',
        'skills',
        'sitemap',
        'sitemaps',
        'state',
        'states',
        'stylesheet',
        'stylesheets',
        'tag',
        'tags',
        'theme',
        'themes',
        'topic',
        'topics',
        'user',
        'username',
        'users',
        'vendor',
        'vendors',
        'vote',
        'votes']

)