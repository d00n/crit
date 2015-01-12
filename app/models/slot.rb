class Slot < ActiveRecord::Base
  belongs_to :event
  
  has_many :slot_game_registrations, :dependent => :destroy
  has_many :games, :through => :slot_game_registrations
  
  after_save :update_games
  
  def registered_players()
    registered_players = []
     
    self.slot_game_registrations.each do |slot_game_registration|
      slot_game_registration.game.player_registrations.each do |player_registration|
        registered_players << User.find_by_id(player_registration.user_id)     
      end
    end
    
    return registered_players
  end 
  
  def registered_in(user)
    self.slot_game_registrations.each do |slot_game_registration|
      slot_game_registration.game.player_registrations.each do |player_registration|
        player = User.find_by_id(player_registration.user_id)    
        if player == user
          return player_registration.game
        end
      end
    end    
  end

  def seats_total
    s = 0
    self.slot_game_registrations.each do |slot_game_registration|
      s += slot_game_registration.game.player_seats
    end
    return s
  end

  def seats_filled
    s = 0
    self.slot_game_registrations.each do |slot_game_registration|
      s += slot_game_registration.game.active_players.size
    end
    return s
  end
  
  def seats_open
    s = 0
    self.slot_game_registrations.each do |slot_game_registration|
      s += slot_game_registration.game.player_seats - slot_game_registration.game.active_players.size
    end
    return s
  end
  
  def update_games
    self.slot_game_registrations.each do |slot_game_registration|
      slot_game_registration.game.start_at = self.start_time
      slot_game_registration.game.end_at = self.start_time + 1
      slot_game_registration.game.session_length = ((self.end_time - self.start_time) / 1.hour).to_i.to_s + ' hours'
      slot_game_registration.game.save
    end
  end  
  
  protected
  def validate
    errors.add("start_time", " must be before end time") unless start_time && end_time && (start_time < end_time)
  end  
  
end
