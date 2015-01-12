class User < ActiveRecord::Base
  require_from_ce('models/user')


  has_many :products, :dependent => :destroy
  has_many :system_categories, :dependent => :destroy

  has_many :characters, :dependent => :destroy
  has_many :games, :dependent => :destroy
  has_many :events, :dependent => :destroy

  has_many :pregenerated_character_requests, :dependent => :destroy
  has_many :player_registrations, :dependent => :destroy
  has_many :games_registered_in, :through => :player_registrations, :source => :game

  has_many :achievements, :dependent => :destroy
  has_many :unlocked_achievements, :dependent => :destroy
  
  has_many :ipn_invoice_notifications
  has_many :ipn_subscription_notifications

  has_one :address, :dependent => :destroy
  #accepts_nested_attributes_for :address, :allow_destroy => true

  #scope :publisher, where(:publisher => true)
  scope :publisher, -> { where(publisher: 'true') }

  #scope :publisher_stale, :conditions => 'publisher is true', :order => 'updated_at DESC'
  scope :publisher_stale, -> { publisher.order('updated_at DESC') }

  #scope :not_publisher, where(:publisher => false)
  scope :not_publisher, -> { where(publisher: 'false') }

  #scope :convention, where(:convention => true)
  scope :convention, -> { where(convention: 'true') }

  #scope :flgs, where(:flgs => true)
  scope :flgs, -> { where(flgs: 'true') }

  #scope :has_blog_rss_url, where('blog_rss_url is not null')
  scope :has_blog_rss_url, -> { where.not(blog_rss_url: '') }

  attr_accessor :authorizing_from_paypal

#  acts_as_authentic do |c|
#    c.validates_format_of_login_field_options = { :with => /^[A-Za-z]+[\sA-Za-z0-9_-]+$/ }
#  end

  def self.build_conditions_for_search(search)
    user = User.arel_table
    users = User.active
    if search['country_id'] && !(search['metro_area_id'] || search['state_id'])
      users = users.where(user[:country_id].eq(search['country_id']))
    end
    if search['state_id'] && !search['metro_area_id']
      users = users.where(user[:state_id].eq(search['state_id']))
    end
    if search['metro_area_id']
      users = users.where(user[:metro_area_id].eq(search['metro_area_id']))
    end
    if search['login']
      users = users.where('`users`.login LIKE ?', "%#{search['login']}%")
    end
    if search['vendor']
      users = users.where(user[:vendor].eq(true))
    end
    if search['chat_admin']
      users = users.where(user[:chat_admin].eq(true))
    end
    if search['description']
      users = users.where('`users`.description LIKE ?', "%#{search['description'].strip}%")
    end
    if search['first_name']
      users = users.where('`users`.first_name LIKE ?', "%#{search['first_name'].strip}%")
    end
    if search['last_name']
      users = users.where('`users`.last_name LIKE ?', "%#{search['last_name'].strip}%")
    end
    if search['publisher_name']
      users = users.where('`users`.publisher_name LIKE ?', "%#{search['publisher_name'].strip}%")
    end
    users
  end

#
#  def compatriots()
#    compatriots = []
#
#    self.characters.each do |character|
#      character.games.each do |game|
#        game.characters.each do |compatriot|
#          if self != compatriot.owner
#            if !compatriots.include?(compatriot)
#              compatriots << compatriot
#            end
#          end
#        end
#      end
#    end
#
#  end

  def display_name
    retval = ""
    if publisher && !publisher_name.blank?
      retval = publisher_name
    else
      if first_name.blank? && last_name.blank?
        return login
      elsif last_name == "."
        retval = first_name
      else
        retval = first_name + " " + last_name
      end
    end

    return retval
  end

  def friend_login_slug_list
    login_slug_list = ''

    self.friendships.each do |friend|
      user = User.find(friend.friend_id)
      if user.login != 'kieara'
        unless login_slug_list.blank?
          login_slug_list += ", "
        end
        login_slug_list += user.login_slug
      end
    end

    return login_slug_list
  end

#  def validate
#    #don't require certain attributes for facebook users
#    %w(password password_confirmation crypted_password birthday email first_name last_name publisher_name).each do |attribute|
#      errors.remove(attribute.to_sym) if facebook_id
#    end
#  end

#  def games_registered_in
#    games_registered_in = []
#    self.player_registrations.each do |player_registration|
#      if player_registration.game
#        games_registered_in << player_registration.game
#      end
#    end
#    return games_registered_in.uniq!
#  end

  def games_starting_soon

    my_games = []
    self.games_registered_in.each do |gri|
      my_games << gri
    end
    self.games.each do |g|
      my_games << g
    end

    my_games.uniq!

    gss = []
    my_games.each do |game|
      if game &&
         game.start_at &&
         (game.start_at > Time.now - 6.hours)
        gss << game
      end
    end

    gss.sort! { |a,b| a.start_at <=> b.start_at }
    return gss
  end


  def self.create_from_authorization(auth, omniauth_hash = nil)
    logger.info "User.create_from_authorization: auth " + auth.inspect
    logger.info "User_create_from_authorization: omniauth_hash " + omniauth_hash.inspect

    user = User.new(:login => auth.nickname, :email => auth.email)

    new_password = user.newpass(8)
    user.password = new_password
    user.password_confirmation = new_password
    user.authorizing_from_omniauth = true
    user.publisher_name = "n/a"
    
    if omniauth_hash && omniauth_hash['extra'] && omniauth_hash['extra']['user_hash']
      if omniauth_hash['extra']['user_hash']['first_name']
        user.first_name = omniauth_hash['extra']['user_hash']['first_name']
      end
      if omniauth_hash['extra']['user_hash']['last_name']
        user.last_name = omniauth_hash['extra']['user_hash']['last_name']
      end
      if omniauth_hash['extra']['user_hash']['birthday']
        user.birthday = omniauth_hash['extra']['user_hash']['birthday']
      end
      if omniauth_hash['extra']['user_hash']['gender']
        if omniauth_hash['extra']['user_hash']['gender'] == 'female'
          user.gender = 'F'
        elsif omniauth_hash['extra']['user_hash']['gender'] == 'male'
          user.gender = 'M'
        end
      end
    else
      name_parts = auth.name.split
      user.first_name = name_parts.shift
      user.last_name = name_parts.join(' ')
      if user.last_name.blank?
        user.last_name = '.'
      end
    end

    user.login = User.create_unique_login(auth.name.tr!(' ', '_'))

    if user.save
      user.activate
      user.reset_persistence_token! #set persistence_token else sessions will not be created
    end
    user
  end

  def self.create_from_paypal(paypal = nil)
    logger.info "User.create_from_paypal: paypal " + paypal.inspect

    user = User.new()

    user.authorizing_from_paypal = true

    new_password = user.newpass(8)
    user.password = new_password
    user.password_confirmation = new_password
    user.authorizing_from_omniauth = false
    user.publisher_name = "n/a"

    if paypal['payer_email']
      user.email = paypal['payer_email']
    end
    if paypal['first_name']
      user.first_name = paypal['first_name']
    end
    if paypal['last_name']
      user.last_name = paypal['last_name']
    end

    user.login = User.create_unique_login(user.first_name + user.last_name)

    if user.save!
      user.activate
      user.reset_persistence_token! #set persistence_token else sessions will not be created
    end

    user
  end

  def self.create_unique_login(name)
    counter = 1
    new_login = name

    while User.find_by_login(new_login)
      suffix = "#{counter += 1}"
      new_login = "#{name}#{suffix}"
    end

    return new_login
  end

  def avatar_photo_url(size = :original)
    if avatar && !avatar.new_record?
      avatar.photo.url(size)
    elsif omniauthed? && authorizations.first.picture_url
      authorizations.first.picture_url
    elsif is_publisher? && dtrpg_logo
      configatron.DTRPG_HOST + dtrpg_logo + "?" + configatron.DTRPG_INFRNO_AFFILIATE_CODE
    else
      case size
        when :thumb
          configatron.photo.missing_thumb.to_s
        else
          configatron.photo.missing_medium.to_s
      end
    end
  end

  def deliver_signup_notification
    if !self.authorizing_from_omniauth
      UserNotifier.signup_notification(self).deliver
    end
  end

  def authored_achievements
    return self.achievements
  end

  def pending_achievements
    return self.unlocked_achievements.where(:accepted => false)
  end

  def accepted_achievements
    return self.unlocked_achievements.where(:accepted => true)
  end

  def granted_achievements
    return self.unlocked_achievements.where(:grantor_id => self.id)
  end

  def total_pending_achievments_count
    count = self.pending_achievements.count
    self.characters.each do |char|
      count += char.pending_achievements.count
    end
    self.games.each do |game|
      count += game.pending_achievements.count
    end

    return count
  end

  #def normalize_friendly_id(slug_string)
  #  options = friendly_id_config.babosa_options.merge(:downcase => false)
  #  slug_string.normalize(options).to_s
  #end

  protected
    def is_publisher?
      self.publisher
    end

    def requires_valid_birthday?
      !(omniauthed? || authorizing_from_paypal)
    end

end
