class Achievement < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_id'

  has_many :unlocked_achievements, :dependent => :destroy

  has_many :users, :through => :unlocked_achievements, :order => 'level DESC'
  has_many :games, :through => :unlocked_achievements, :order => 'level DESC'
  has_many :characters, :through => :unlocked_achievements, :order => 'level DESC'

  validates :name, :presence => true
  validates :description, :presence => true

  scope :others_can_grant, where('achievements.others_can_grant = 1')

  has_attached_file :avatar, configatron.avatar.paperclip_options.to_hash
  validates_attachment_presence :avatar
  validates_attachment_content_type :avatar, :content_type => configatron.avatar.validation_options.content_type
  validates_attachment_size :avatar, :less_than => configatron.avatar.validation_options.max_size.to_i.megabytes

  has_attached_file :badge, configatron.badge.paperclip_options.to_hash
  validates_attachment_presence :badge
  validates_attachment_content_type :badge, :content_type => configatron.badge.validation_options.content_type
  validates_attachment_size :badge, :less_than => configatron.badge.validation_options.max_size.to_i.megabytes

  has_attached_file :thumb, configatron.thumb.paperclip_options.to_hash
  validates_attachment_presence :thumb
  validates_attachment_content_type :thumb, :content_type => configatron.thumb.validation_options.content_type
  validates_attachment_size :thumb, :less_than => configatron.thumb.validation_options.max_size.to_i.megabytes
  
  acts_as_activity :user

  def has_been_accepted
    self.unlocked_achievements.each do |ua|
      if ua.accepted
        return true
      end
    end
    return false
  end

  def to_param
    id.to_s << "-" << (name ? name.parameterize : '' )
  end

end
