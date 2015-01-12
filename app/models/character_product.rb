class CharacterProduct < ActiveRecord::Base
  belongs_to :character, :counter_cache => :products_counter
  belongs_to :product, :counter_cache => :games_counter
end
