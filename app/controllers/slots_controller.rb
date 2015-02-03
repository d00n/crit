class SlotsController < BaseController

  def choose_game
    @slot = Slot.find(params[:id])
  end

  def register_game
    slot = Slot.find(params[:id])
    game = Game.find(params[:game_id])

    if current_user && slot && game && slot.event.is_registering_games
      clonedGame = game.get_clone(current_user)

      slotGameRegistration = SlotGameRegistration.new
      slot.slot_game_registrations << slotGameRegistration
      clonedGame.slot_game_registrations << slotGameRegistration
      slotGameRegistration.status = 'pending'
      slotGameRegistration.save
      

      # Assume that games for events should be closed for registration
      clonedGame.updateWithSlotInfo(slot)
      clonedGame.status = 'closed'
      clonedGame.auto_approve_player_registrations = true
      clonedGame.alternate_seats = EVENT_ALTERNATE_SEATS
      clonedGame.start_at = slot.start_time
      clonedGame.end_at = slot.start_time + 1
      clonedGame.session_length = ((slot.end_time - slot.start_time) / 1.hour).to_i.to_s + ' hours'
      clonedGame.save

      UserNotifier.slot_register_game_notice(slotGameRegistration).deliver

      flash[:notice] = "#{clonedGame.name} has been registered.".html_safe
    else
      flash[:error] = 'Event is not open for registration.'
    end

    redirect_to event_path(slot.event)
  end

  def register_new_game
    redirect_to :action => 'new', :controller => 'games', :register_slot_id => params[:id]
  end

  def approve_game
    slotGameRegistration = SlotGameRegistration.find_by_slot_id_and_game_id_and_status(params[:id], params[:game_id], 'pending')

    if slotGameRegistration && current_user && current_user == slotGameRegistration.slot.event.owner
      slotGameRegistration.status = 'active'
      slotGameRegistration.save


      if slotGameRegistration.slot.event.is_registering_regular_players || slotGameRegistration.slot.event.is_registering_premium_players
        slotGameRegistration.game.status = 'open'
      else
        slotGameRegistration.game.status = 'closed'
      end
      slotGameRegistration.game.save!

      UserNotifier.slot_approve_game_notice(slotGameRegistration).deliver
    else
      flash[:error] = 'You may not approve registrations for an event you do not own.'
    end

    redirect_to event_path(slotGameRegistration.slot.event)
  end

  def deny_game
    slotGameRegistration = SlotGameRegistration.find_by_slot_id_and_game_id_and_status(params[:id], params[:game_id], 'pending')

    if slotGameRegistration && current_user && current_user == slotGameRegistration.slot.event.owner
      UserNotifier.slot_deny_game_notice(slotGameRegistration).deliver
      slotGameRegistration.destroy
    else
      flash[:error] = 'You may not deny registrations for an event you do not own.'
    end

    redirect_to event_path(slotGameRegistration.slot.event)
  end

  def kick_game
    slotGameRegistration = SlotGameRegistration.find_by_slot_id_and_game_id_and_status(params[:id], params[:game_id], 'active')

    if slotGameRegistration && current_user && current_user == slotGameRegistration.slot.event.owner
      UserNotifier.slot_kick_game_notice(slotGameRegistration).deliver
      slotGameRegistration.destroy
    else
      flash[:error] = 'You may not kick games from an event you do not own.'
    end

    redirect_to event_path(slotGameRegistration.slot.event)
  end

  def cancel_game
    slotGameRegistration = SlotGameRegistration.find_by_slot_id_and_game_id(params[:id], params[:game_id])

    if slotGameRegistration && current_user && current_user == slotGameRegistration.game.owner
      UserNotifier.slot_cancel_game_notice(slotGameRegistration).deliver
      slotGameRegistration.destroy
    else
      flash[:error] = 'You may not cancel a registration you do not own.'
    end

    redirect_to event_path(slotGameRegistration.slot.event)
  end

  protected
  def slot_params
    params.require(:slot).permit(:name,
                         :start_time,
                         :end_time)
  end

end
