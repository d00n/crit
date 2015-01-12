class SlotGameRegistration < ActiveRecord::Base
  belongs_to :slot
  belongs_to :game
end
