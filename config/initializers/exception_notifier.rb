if Rails.env.production? || Rails.env.staging? || Rails.env.development?

  Crit::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[ERROR] ",
    :sender_address => '"Notifier" <notifier@infrno.net>',
    :exception_recipients => ['rails_exceptions@infrno.net'],
    :sections => %w(request session backtrace)
end