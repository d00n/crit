class PregeneratedCharacterRequest < ActiveRecord::Base
  belongs_to :character
  belongs_to :game
  belongs_to :user
  
  def owner
    self.user
  end
  
  def self.fetch(character_id, game_id, user_id)
    self.find(:first, :conditions => ['character_id = ? and game_id = ? and user_id = ?', character_id, game_id, user_id])
  end
end
