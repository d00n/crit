class Photo < ActiveRecord::Base
  require_from_ce('models/photo')

  #attr_accessible :is_private, :album_id
  
  def previous_photo
    self.user.photos.where('created_at < ?', created_at).first
  end
  def next_photo
    self.user.photos.where('created_at > ?', created_at).last
  end

  def previous_in_album
    return nil unless self.album
    self.user.photos.where('created_at < ? and album_id = ?', created_at, self.album.id).first
  end
  def next_in_album
    return nil unless self.album    
    self.user.photos.where('created_at > ? and album_id = ?', created_at, self.album_id).last
  end

  def has_access(user)
    if !self.is_private
      return true
    end

    if user && user == self.user
      return true
    end

    return false
  end
end
