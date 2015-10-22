Crit::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  config.action_view.raise_on_missing_translations = true

  config.active_record.default_timezone = :utc

  config.action_mailer.smtp_settings = { :enable_starttls_auto => false }

  # gametable vars
  APP_URL = "http://localhost:3000"

  LIBRARY_SERVER = "http://kieara"
  LIBRARY_BASE_PATH = "/libraries/"
  LIBRARY_REGISTRY_FILE = "libraries.xml"

  IMAGE_SERVER = "http://kieara"

  WOWZA_SERVER = "rtmp://kieara"
  ROOM_ID_SERVER = "http://localhost"
  MINT_VERSION = "60"
  OT_MINT_VERSION = "71"
  CACHE_SERVER_7 = "http://localhost:3000"
  CACHE_SERVER_8 = "http://localhost:3000"
  CACHE_SERVER_9 = "http://localhost:3000"

  FACEBOOK_CONNECT = true
  FACEBOOK_CONNECT_STEALTH_TEST = false
  FACEBOOK_LIKE = false

  DEPLOY_GOOGLE_ANALYTICS = false
  DEPLOY_QUANTCAST = false
  DEPLOY_ENVOLVED = false
  DEPLOY_CHATCAT = false
  DEPLOY_ADDTOANY = false
  DEPLOY_ADDTHIS = false
  WOWZA_SECRET_KEY = "871a3f2c392e10ca2e04c442f1eedb65"
  WOWZA_WHITEBOARD_APP = "whiteboard"
  WOWZA_CHAT_APP = "chat"

  OPENTOK_API_KEY = "8248452"
  OPENTOK_API_SECRET = "632a2ffe32d64987c12de01ad4b5099a936c96d3"
  OPENTOK_JAVASCRIPT_SRC = "http://staging.tokbox.com/v0.91.56/js/TB.min.js"
  OPENTOK_API_URL = "https://staging.tokbox.com/hl"
  OPENTOK_CONNECTION_DEBUGGING = false
  OPENTOK_REMOTE_STREAMS = 7

  EVENT_ALTERNATE_SEATS = 2

  GAMETABLE_DOWN_FOR_MAINT = false
  GAMETABLE_PEER_ENABLED = false
  SWFVERSIONSTR = "10.1.0"
  #GAMETABLE_GOOGLE_ANALYTICS_REPORT_INTERVAL_SECONDS = 5
  #GAMETABLE_GOOGLE_ANALYTICS_DEBUG_MODE = true

  UPCOMING_GAME_NOTIFICATION_DAYS = 30


  BOOTH_VISIT_ACHIEVEMENT_ENABLED = false
  BOOTH_VISIT_ACHIEVEMENT_ID = 1
  BOOTH_VISIT_REMOTE_IP = '127.0.'

  CON_GAME_ID = ''

  ENVOLVE_API_KEY = '140-tlUfHfyhmMjDupqHwmQCoIHnrUHzCqUL'


  PAYPAL_CERT = "/config/certs/test_paypal_cert.pem"
  INFRNO_CERT = "/config/certs/test_infrno_cert.pem"
  INFRNO_KEY = "/config/certs/test_infrno_key.pem"
  PAYPAL_EMAIL= "paypal_1331429423_biz@infrno.net"
  PAYPAL_CERT_ID= "WXVPCQBWUJ9M6"
  PAYPAL_URL= "https://www.sandbox.paypal.com/cgi-bin/webscr"

  #ActiveMerchant::Billing::Base.gateway_mode = :test
  ##ActiveMerchant::Billing::Base.integration_mode = :test
  #ActiveMerchant::Billing::PaypalGateway.pem_file = File.read(Rails.root.to_s + PAYPAL_CERT)

  WIZARDS_USER_ID= 21612
  PAIZO_USER_ID= 21611
end
