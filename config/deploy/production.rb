# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server 'example.com', user: 'deploy', roles: %w{app db web}, my_property: :my_value
# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
# server 'db.example.com', user: 'deploy', roles: %w{db}



# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }


APP_URL = "http://www.infrno.net"

LIBRARY_SERVER = "http://www.infrno.net"
LIBRARY_BASE_PATH = "/libraries/"
LIBRARY_REGISTRY_FILE = "libraries.xml"

IMAGE_SERVER = "http://wowza.infrno.net"

WOWZA_SERVER = "rtmp://wowza.infrno.net"
ROOM_ID_SERVER = "http://wowza.infrno.net"
MINT_VERSION = "60"
OT_MINT_VERSION = "72"
GAMETABLE_DOWN_FOR_MAINT = false
GAMETABLE_PEER_ENABLED = false
SWFVERSIONSTR = "10.1.0"
#GAMETABLE_GOOGLE_ANALYTICS_REPORT_INTERVAL_SECONDS = 60
#GAMETABLE_GOOGLE_ANALYTICS_DEBUG_MODE = false

UPCOMING_GAME_NOTIFICATION_DAYS = 3


CACHE_SERVER_7 = "http://www.infrno.net"
CACHE_SERVER_8 = "http://www.infrno.net"
CACHE_SERVER_9 = "http://www.infrno.net"

FACEBOOK_CONNECT = true
FACEBOOK_CONNECT_STEALTH_TEST = false
FACEBOOK_LIKE = true

DEPLOY_GOOGLE_ANALYTICS = true
DEPLOY_QUANTCAST = false
DEPLOY_ENVOLVED = false
DEPLOY_CHATCAT = true
DEPLOY_ADDTOANY = false
DEPLOY_ADDTHIS = false
WOWZA_SECRET_KEY = "871a3f2c392e10ca2e04c442f1eedb65"
WOWZA_WHITEBOARD_APP = "whiteboard"
WOWZA_CHAT_APP = "chat"

OPENTOK_API_KEY = "8248452"
OPENTOK_API_SECRET = "632a2ffe32d64987c12de01ad4b5099a936c96d3"
OPENTOK_JAVASCRIPT_SRC = "http://static.opentok.com/v0.91.56/js/TB.min.js"
OPENTOK_API_URL = "https://api.opentok.com/hl"
OPENTOK_CONNECTION_DEBUGGING = false
OPENTOK_REMOTE_STREAMS = 7

EVENT_ALTERNATE_SEATS = 2

BOOTH_VISIT_ACHIEVEMENT_ENABLED = false
BOOTH_VISIT_ACHIEVEMENT_ID = 10
BOOTH_VISIT_REMOTE_IP = '75.211.81'

CON_GAME_ID = ''

ENVOLVE_API_KEY = '1497-ovrudelSPzcHnqOhnRHHsPfWEhTgRavi'

config.log_level = :info

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    :address => "localhost",
    :port => "25",
    :domain => "infrno.net"
}

#config.action_controller.asset_host= Proc.new { |source|
#  if source.starts_with?('/assets/tiny_mce')
#    "http://www.infrno.net"
#  else
#    "http://cdn#{rand(3)}.infrno.net"
#  end
#}

PAYPAL_CERT = "/config/certs/paypal_cert.pem"
INFRNO_CERT = "/config/certs/infrno_cert.pem"
INFRNO_KEY = "/config/certs/infrno_key.pem"
PAYPAL_EMAIL= "paypal@infrno.net"
PAYPAL_CERT_ID= "FC2W3PRULU66N"
PAYPAL_URL= "https://www.paypal.com/cgi-bin/webscr"

ActiveMerchant::Billing::Base.gateway_mode = :production
#ActiveMerchant::Billing::Base.integration_mode = :production
ActiveMerchant::Billing::PaypalGateway.pem_file = File.read(Rails.root.to_s + PAYPAL_CERT)

WIZARDS_USER_ID= 21612
PAIZO_USER_ID= 21611
