class Event < ActiveRecord::Base
  require 'builder'
  belongs_to :user
  belongs_to :avatar, :class_name => "Photo", :foreign_key => "avatar_id"  
  
  has_many :slots, :dependent => :destroy
  accepts_nested_attributes_for :slots, :allow_destroy => true
  
  after_save :update_player_reg_desks
  
  has_many :posts, -> {order "published_at desc"}
    
  acts_as_commentable
  acts_as_taggable  
  acts_as_activity :user
  
  validates_presence_of :name  
  scope :recent, -> {order 'events.updated_at DESC'}
  
  #attr_protected :user_id
  
  #Procs used to make sure time is calculated at runtime
  #scope :upcoming, lambda { { :order => 'start_time', :conditions => ['end_time > ?' , Time.now ] } }
  #scope :past, lambda { { :order => 'start_time DESC', :conditions => ['end_time <= ?' , Time.now ] } }  
  
  def to_param
    id.to_s << "-" << (name ? name.parameterize : '' )
  end
  
  def owner
    self.user
  end
  
  def avatar_photo_url(size = nil)
    if avatar
      avatar.photo.url(size)
    else
      case size
        when :thumb
          configatron.photo.missing_thumb.to_s
        else
          configatron.photo.missing_medium.to_s
      end
    end
  end
  
  # Search, pagination code - START  
  def self.paginated_users_conditions_with_search(params)
    search = prepare_params_for_search(params)
    
    cond = build_conditions_for_search(search)
    return cond, search
  end   
 
  def self.prepare_params_for_search(params)
    search = {}.merge(params)
    search['event_id'] = params[:event_id] || nil
    search
  end
      
    
  def self.build_conditions_for_search(search)
    cond = Caboose::EZ::Condition.new

    #cond.append ['activated_at IS NOT NULL ']
    if search['name']    
      cond.append ["events.name like ?", "%#{search['name']}%"]    
    end  
    cond
  end 
  # Search, pagination code - END    
  
  def time_and_date
    if spans_days?
      string = "#{start_time.strftime("%B %d")} to #{end_time.strftime("%B %d %Y")}"
    else
      string = "#{start_time.strftime("%B %d, %Y")}, #{start_time.strftime("%I:%M %p")} - #{end_time.strftime("%I:%M %p")}"
    end
  end

  def spans_days?
    (end_time - start_time) >= 86400
  end

  def gm_login_slug_list
    login_slug_list = ''
    gm_array = []

    self.slots.each do |slot|
      slot.games.each do |game|
        gm_array << game.owner
      end
    end

    gm_array_unique = gm_array.uniq

    gm_array_unique.each do |gm|
      unless login_slug_list.blank?
        login_slug_list += ", "
      end
      login_slug_list += gm.login_slug
    end

    return login_slug_list
  end

  def player_login_slug_list
    login_slug_list = ''
    player_array = []

    self.slots.each do |slot|
      slot.games.each do |game|
        game.active_players.each do |player|
          player_array << player
        end
      end
    end

    player_array_unique = player_array.uniq

    player_array_unique.each do |player|
      unless login_slug_list.blank?
        login_slug_list += ", "
      end

      login_slug_list += player.login_slug
    end

    return login_slug_list
  end

  def alternate_login_slug_list
    login_slug_list = ''
    alternate_array = []

    self.slots.each do |slot|
      slot.games.each do |game|
        game.alternate_players.each do |alternate|
          alternate_array << alternate
        end
      end
    end

    alternate_array_unique = alternate_array.uniq

    alternate_array_unique.each do |alternate|
      unless login_slug_list.blank?
        login_slug_list += ", "
      end
      login_slug_list += alternate.all.first.login_slug
    end

    return login_slug_list
  end

  def registered_players()
    registered_players = []

    self.slots.each do |slot|
      registered_players << slot.registered_players
    end

    registered_players.uniq!
    return registered_players
  end

  def seats_total
    s = 0
    self.slots.each do |slot|
      s += slot.seats_total
    end
    return s
  end

  def seats_filled
    s = 0
    self.slots.each do |slot|
      s += slot.seats_filled
    end
    return s
  end

  def seats_open
    s = 0
    self.slots.each do |slot|
      if slot.start_time > Time.now
        s += slot.seats_open
      end
    end
    return s
  end
  
  def update_player_reg_desks
    self.slots.each do |slot|
      slot.games.each do |game|
        if self.is_registering_regular_players || self.is_registering_premium_players
          game.status = 'open'
        else
          game.status = 'closed'
        end       
        game.save
      end
    end
  end

  def upcoming_games
    games = []
    self.slots.where("start_time > ?", Time.now).each do |slot|
      slot.games.each do |game|
        games << game
      end
    end
   return games
  end

  protected
  def validate
    errors.add("start_time", " must be before end time") unless start_time && end_time && (start_time < end_time)
  end

end
