class MembershipsController < BaseController

  def premium_membership_brb
    @sample_achievements = []
    @sample_achievements << Achievement.find(8)
    @sample_achievements << Achievement.find(11)
    @sample_achievements << Achievement.find(7)
    @sample_achievements << Achievement.find(3)
  end

  def premium_membership
    @hide_nav_items = true
    @events_game_total = 0
    @events_player_total = 0

    Event.all.each do |event|
      event.slots.each do |slot|
        slot.games.each do |game|
          @events_game_total += 1
          # Don't forget the GM
          @events_player_total += 1
          game.active_players.each do |player|
            @events_player_total += 1
          end
        end
      end
    end

    @events_hour_total = @events_player_total * 4

    @sample_achievements = []
    @sample_achievements << Achievement.find(8)
    @sample_achievements << Achievement.find(11)
    @sample_achievements << Achievement.find(7)
    @sample_achievements << Achievement.find(3)
  end

  def discounts
    render :layout => 'single_column'
  end

  def thank_you
    render :layout => 'single_column'
  end

end
