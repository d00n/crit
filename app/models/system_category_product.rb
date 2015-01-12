class SystemCategoryProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :system_category, :counter_cache => :products_counter
end
