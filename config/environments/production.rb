Crit::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both thread web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  # TODO turn this off
  #config.consider_all_requests_local       = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like nginx, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable Rails's static asset server (Apache or nginx will already do this).
  config.serve_static_assets = false

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = '1.0'

  # Specifies the header that your server uses for sending files.
  config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Set to :debug to see everything in the log.
  config.log_level = :info
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets.
  # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
  # config.assets.precompile += %w( search.js )

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Disable automatic flushing of the log to improve performance.
  # config.autoflush_log = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new


  config.action_mailer.smtp_settings = { :enable_starttls_auto => true }

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

  DEPLOY_SCROLLBACK = true
  DEPLOY_GOOGLE_ANALYTICS = true
  DEPLOY_QUANTCAST = false
  DEPLOY_ENVOLVED = false
  DEPLOY_CHATCAT = false
  DEPLOY_ADDTOANY = false
  DEPLOY_ADDTHIS = false
  WOWZA_SECRET_KEY = "871a3f2c392e10ca2e04c442f1eedb65"
  WOWZA_WHITEBOARD_APP = "whiteboard"
  WOWZA_CHAT_APP = "chat"

  D20PRO_SECRET = "roll20_can_suck_my_balls"

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


  MANDRILL_USERNAME = 'mike@infrno.net'
  MANDRILL_API_KEY = 'B9hrczI6VOKbwx3Kk0TD1Q'

  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
      :address   => "smtp.mandrillapp.com",
      :port      => 25,
      :enable_starttls_auto => true,
      :user_name => "mike@infrno.net",
      :password  => "B9hrczI6VOKbwx3Kk0TD1Q",
      :authentication => 'login',
      :domain => 'infrno.net'
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

end
