namespace :user_notifications do

  desc "Send upcoming game reminder emails"
  task :upcoming_games => :environment do
    logger = Logger.new('log/rake_user_notifications.log')
    logger.info "#{Time.now} Sending upcoming game reminder emails"

    games_in_next_day = Game.where("start_at > ? and start_at < ?", Time.now, Time.now + 1.days)
    games_in_three_days = Game.where("start_at > ? and start_at < ?", Time.now + 2.days, Time.now + 3.days)

    logger.info("games_in_next_day #{games_in_next_day.size}")
    logger.info("games_in_three_days #{games_in_three_days.size}")

    user_ids = []

    games_in_next_day.each do |game|
      if game.owner.notify_upcoming_games
        user_ids << game.owner.id
      end

      game.active_players.each do |player|
        if player.notify_upcoming_games
          user_ids << player.id
        end
      end

      game.alternate_players.each do |player|
        if player.notify_upcoming_games
          user_ids << player.id
        end
      end
    end

    games_in_three_days.each do |game|
      if game.owner.notify_upcoming_games
        user_ids << game.owner.id
      end

      game.active_players.each do |player|
        if player.notify_upcoming_games
          user_ids << player.id
        end
      end

      game.alternate_players.each do |player|
        if player.notify_upcoming_games
          user_ids << player.id
        end
      end
    end


    user_ids.uniq!
    logger.info "user_ids.size #{user_ids.size}"

    user_ids.each do |user_id|
      user = User.find(user_id)
      logger.info "#{user.games_starting_soon.size} games, #{user.email}, #{user.display_name}"
      UserNotifier.upcoming_game_notification(user).deliver
    end
  end


  desc "Send 10 test emails"
  task :send_test_emails => :environment do
    logger = Logger.new('log/rake_user_notifications_test.log')
    logger.info "#{Time.now} Sending test emails"

    user = User.find(5)

    (1..10).each do |i|
      logger.info "Test: #{i}"
      UserNotifier.upcoming_game_notification(user).deliver
    end
  end
end


