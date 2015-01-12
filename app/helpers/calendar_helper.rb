module CalendarHelper
  def month_link(month_date)
    link_to(I18n.localize(month_date, :format => "%B"), {:month => month_date.month, :year => month_date.year})
  end
  
  # custom options for this calendar
  def event_calendar_opts
    { 
      :year => @year,
      :month => @month,
      :event_strips => @event_strips,
      :month_name_text => I18n.localize(@shown_month, :format => "%B %Y"),
      :previous_month_text => "<< " + month_link(@shown_month.prev_month),
      :next_month_text => month_link(@shown_month.next_month) + " >>"    }
  end

  def event_calendar
    # args is an argument hash containing :event, :day, and :options
    calendar event_calendar_opts do |args|
      event = args[:event]
      
      d = Date.civil(event.start_at.in_time_zone.year.to_i, event.start_at.in_time_zone.month.to_i, event.start_at.in_time_zone.day.to_i)
      
      if d.cwday == 5 || d.cwday == 6
        new_tip = "new Tip('game_#{event.id}', $('tooltip_#{event.id}'),  {hideOn: false, hook: {target: 'topLeft', tip: 'topRight'}, hideAfter: .5, className: 'gametip',});"
      else        
        new_tip = "new Tip('game_#{event.id}', $('tooltip_#{event.id}'),  {hideOn: false, hook: {target: 'topRight', tip: 'topLeft'}, hideAfter: .5, className: 'gametip',});"
      end
      
      li_system = ''
      if !event.system_name.blank?
        li_system = "<li>System: "
        li_system += link_to h(event.system_name), games_path(:system_name => event.system_name)
        li_system += "</li>"
      end

      alternate_seats = ''
      if event.open_alternate_seats > 0
        alternate_seats = "<li> Open alternate seats: #{event.open_alternate_seats}</li>"
      end

      active_players = ''
      event.active_players.each do |active_player|

        active_players <<
          %(
            <p>
              #{link_to image_tag(active_player.avatar_photo_url(:thumb), :width => '50', :height => '50', :alt => h(active_player.display_name)), user_path(active_player)}
              Player<br>
              #{link_to h(active_player.display_name), user_path(active_player)}
            </p>
          )
      end


      %(
      <a href="/games/#{event.id}" id="game_#{event.id}" >#{h(event.name)}</a>
      <div id="tooltip_#{event.id}">
        #{link_to image_tag( event.avatar_photo_url(:thumb), :width => "100" ), seo_game_path(event)}
        <h2>#{link_to h(event.name), seo_game_path(event)}</h2>
                  <ul>
                  <li>GM: #{link_to event.owner.display_name, user_path(event.owner)}</li>
                  #{li_system}
                    <li>Time: #{event.start_at.strftime('%I:%M%p %Z')}</li>
                    <li>Length: #{h event.session_length}</li>
                    <li> Open player seats: #{event.open_player_seats}</li>
                    #{alternate_seats}
                    <li>#{link_to "Registration desk", registration_desk_path(event)}</li>
                  </ul>
                <p>
                <div class='game_description'>
                  #{h(truncate_words event.description, 50, '...')}
                </div>
                <p>
              <div class='registration_desk'>
                <p>
                  #{link_to image_tag(event.owner.avatar_photo_url(:thumb), :width => '50', :height => '50', :alt => h(event.owner.display_name)), user_path(event.owner)}
                  GM<br>
                  #{link_to h(event.owner.display_name), user_path(event.owner)}
                </p>                
                #{active_players}
              </div>
      </div>
      <script type='text/javascript'>
        #{new_tip}
      </script>
      )
    end
  end
  
end