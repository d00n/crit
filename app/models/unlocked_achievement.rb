class UnlockedAchievement < ActiveRecord::Base
    belongs_to :grantor, :class_name => 'User', :foreign_key => 'grantor_id'

    belongs_to :user
    belongs_to :character
    belongs_to :game
    
    belongs_to :achievement

    acts_as_activity :user

    scope :winners, :order => 'level desc'
    scope :user_winners, where("user_id is not null")

  def has_access(user)
    if user &&
        (self.user && self.user == user) ||
        (self.game && self.game.owner == user) ||
        (self.character && self.character.owner == user)
      
      return true
    end

    return false
  end



end
