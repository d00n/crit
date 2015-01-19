class Product < ActiveRecord::Base
  belongs_to :user

  validates_length_of("name", :minimum => 3)

  has_many :posts, -> { order 'published_at desc' }

  acts_as_commentable
  acts_as_taggable
  scope :recent, -> {order 'products.created_at DESC'}
  scope :dtrpg, -> {where('dtrpg_product_id is not NULL')}
  scope :dtrpg_stale, -> {dtrpg.order 'products.updated_at DESC'}

  scope :is_featured,-> {where("featured_product_rank > 0") }
  scope :featured,-> {is_featured.order 'products.featured_product_rank ASC'}

  scope :is_featured_displayed, -> {where("featured_product_rank > 0") }
  scope :featured_displayed, -> {is_featured_displayed.order 'products.featured_product_rank ASC'}

  scope :is_featured_not_displayed, -> {where("featured_product_rank = 0 or featured_product_rank is null")}
  scope :featured_not_displayed, -> {is_featured_not_displayed.order 'products.name ASC'}

  scope :is_catalog, -> {where("catalog_rank > 0")}
  scope :catalog, -> {is_catalog.order 'products.catalog_rank ASC'}

  scope :is_catalog_displayed, -> {where("catalog_rank > 0")}
  scope :catalog_displayed, -> {is_catalog_displayed.order 'products.catalog_rank ASC'}

  scope :is_catalog_not_displayed, -> {where("catalog_rank = 0 or catalog_rank is null")}
  scope :catalog_not_displayed, -> {is_catalog_not_displayed.order 'products.name ASC'}

  scope :popular, -> {order 'products.view_count DESC'}

  belongs_to  :avatar, :class_name => "Photo", :foreign_key => "avatar_id"
#  has_one  :artwork, :class_name => "Artwork", :as => :owner
#  has_one  :logo, :class_name => "Logo", :foreign_key => "product_id"

  has_many :game_products, :dependent => :destroy
  has_many :games, -> {order "updated_at desc"}, :through => :game_products

  has_many :character_products, :dependent => :destroy
  has_many :characters, -> {order "updated_at desc"}, :through => :character_products

  has_many :system_category_products, :dependent => :destroy
  has_many :system_categories, :through => :system_category_products


  def self.search_conditions(params)
    search = prepare_params_for_search(params)
    products = build_conditions_for_search(search)
    return products, search
  end


  def self.prepare_params_for_search(params)
    search = {}.merge(params)
    search['genre'] = params[:genre] || nil
    search['name'] = params[:name] || nil
    search['is_core_rulebook'] = params[:is_core_rulebook] || nil
    search['publisher_id'] = params[:publisher_id] || nil
    search
  end

  def self.build_conditions_for_search(search)
    products = Product.popular

    if !search['publisher_id'].blank? && publisher = User.find(search['publisher_id'])
      products = products.where("user_id = ?", publisher.id)
    end
    if !search['name'].blank?
      products = products.where("name like ?", "%#{search['name'].strip}%")
    end
    if !search['genre'].blank?
      products = products.where( :genre => search['genre'] )
    end
    if !search['is_core_rulebook'].blank? && search['is_core_rulebook'] == 'on'
      products = products.where( :is_core_rulebook => true )
    end

    products
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
  #
  ## @param id [Object]
  ## @param counter_name [Object]
  #def update_counters(id, counter_name)
  #  super
  #end
  #
  #def increment_counter(counter_name, id)
  #  super
  #
  #  self.system_categories.each do |system_category|
  #    system_category.increment_counter(counter_name, id)
  #  end
  #end
  #def increment(counter_name, id)
  #  super
  #
  #  self.system_categories.each do |system_category|
  #    system_category.increment_counter(counter_name, id)
  #  end
  #end
  #def increment!(counter_name, id)
  #  super
  #
  #  self.system_categories.each do |system_category|
  #    system_category.increment_counter(counter_name, id)
  #  end
  #end
  #
  #def decrement_counter(counter_name, id)
  #  super
  #
  #  self.system_categories.each do |system_category|
  #    system_category.decrement_counter(counter_name, id)
  #  end
  #end

end
