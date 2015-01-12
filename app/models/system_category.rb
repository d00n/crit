class SystemCategory < ActiveRecord::Base
  extend FriendlyId

  belongs_to :user
  validates_length_of("name", :minimum => 3)

  belongs_to  :avatar, :class_name => "Photo", :foreign_key => "avatar_id"

  #has_and_belongs_to_many :products
  has_many :system_category_products, :dependent => :destroy
  has_many :products, :through => :system_category_products

  friendly_id :name, :use => [:slugged, :finders]

  #scope :popular, :order => 'system_categories.view_count DESC'

  acts_as_commentable
  acts_as_taggable

  def self.popular
     where('products_counter > 0').order('system_categories.view_count DESC')
  end

  def self.search_conditions(params)
    search = prepare_params_for_search(params)
    system_categories = build_conditions_for_search(search)
    return system_categories, search
  end


  def self.prepare_params_for_search(params)
    search = {}.merge(params)
    search['name'] = params[:name] || nil
    search['user_id'] = params[:user_id] || nil
    search
  end

  def self.build_conditions_for_search(search)
    system_categories = SystemCategory.popular

    if !search['user_id'].blank?
      system_categories = system_categories.where("user_id = ?", "%#{search['user_id'].strip}%")
    end
    if !search['name'].blank?
      system_categories = system_categories.where("name like ?", "%#{search['name'].strip}%")
    end

    system_categories
  end

  def owner
    self.user
  end
  
  def first_image_in_description(size = nil, options = {})
    doc = Hpricot( description )
    image = doc.at("img")
    image ? image['src'] : nil
  end
  
  def avatar_photo_url(size = nil)
    if avatar
      avatar.photo.url(size)
    else
      case size
        when :thumb
          configatron.photo['missing_thumb']
        else
          configatron.photo['missing_medium']
      end
    end
  end
end
