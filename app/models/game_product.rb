class GameProduct < ActiveRecord::Base
  belongs_to :game, :counter_cache => :products_counter
  belongs_to :product, :counter_cache => :games_counter
end
