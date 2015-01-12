class CharacterRegistration < ActiveRecord::Base
  belongs_to :character
  belongs_to :game
  belongs_to :player_registration
  
  def self.fetch(character_id, game_id, status)
    self.all(:conditions => ['character_id = ? and game_id = ? and status = ?', character_id, game_id, status])
  end
  
  def activate!
    update_attribute(:status, "active")
  end
  
end
