class Post < ActiveRecord::Base
  require_from_ce('models/post')

  belongs_to :game
  belongs_to :character

  class << self

    def system_announcement
      where("posts.is_system_announcement = true").order("posts.published_at DESC").limit(1)
    end

  end

  def has_access(user)    
    if self.game 
      return self.game.has_access(user)
    end

    if self.character
      return self.character.has_access(user)
    end

    return true
  end

end
