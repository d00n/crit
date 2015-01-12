class Comment < ActiveRecord::Base
  require_from_ce('models/comment')

  def commentable_name
    type = self.commentable_type.underscore
    case type
      when 'user'
        commentable.display_name
      when 'character'
        commentable.name
      when 'game'
        commentable.name
      when 'post'
        commentable.title
      when 'clipping'
        commentable.description || "clipping from #{commentable.user.display_name}"
      when 'photo'
        commentable.description || "photo from #{commentable.user.display_name}"
      else 
        commentable.class.to_s.humanize
    end
  end


  def unsubscribe_notifications(email)
    user = User.find_by_email(email)
    
    commentable.comments.find_all_by_user_id(user.id).each do |previous_comment|
      previous_comment.update_attribute :notify_by_email, false
    end
  end

  #def token_for(email)
  #  Digest::SHA1.hexdigest("#{id}--#{email}--#{created_at.utc}")
  #end


  def has_access(user)
    if user && user == self.user
      return true
    end

    if self.commentable_type.underscore == 'character'
      character = self.commentable
      return character.has_access(user)
    end
      
    if  self.commentable_type.underscore == 'game'
      game = self.commentable
      return game.has_access(user)
    end

    if (self.commentable_type.underscore == 'post')
      post = self.commentable
      if post.game
        return post.game.has_access(user)
      end
      if post.character
        return post.character.has_access(user)
      end
    end

    return true
  end

end
