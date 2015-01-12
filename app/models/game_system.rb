class GameSystem < ActiveRecord::Base
  has_many :games
  
  def update_game_counts
    self.total_game_count = Game.find_all_by_game_system_id(self).length
    self.open_game_count  = Game.find_all_by_game_system_id_and_status(self, 'open').length
    self.save
  end
end
