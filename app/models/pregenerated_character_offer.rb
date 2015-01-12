class PregeneratedCharacterOffer < ActiveRecord::Base
  belongs_to :character
  belongs_to :game
  
  def self.fetch(character_id, game_id)
    self.find(:first, :conditions => ['character_id = ? and game_id = ?', character_id, game_id])
  end
end
