class PlayerRegistration < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_many :character_registrations, :dependent => :destroy
  
  def self.fetch(game_id, user_id, status)
    self.find(:first, :conditions => ['user_id = ? and game_id = ? and status = ?', user_id, game_id, status])
  end
  
  def activate!
    update_attribute(:status, "active")
  end
  
end
