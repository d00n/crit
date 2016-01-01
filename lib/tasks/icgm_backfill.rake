task :icgm_backfill => :environment do

  logger = Logger.new('log/rake_icgm_backfill.log')
  logger.info "#{Time.now}"

  achievement = Achievement.find(1)

  events = []
  events << Event.find(1)
  events << Event.find(5)
  events << Event.find(7)
  events << Event.find(9)
  events << Event.find(11)

  gms = []

  events.each do |event|
    logger.info("#{event.name}")
    event.slots.each do |slot|
      logger.info("#{event.name} : #{slot.name}")
      slot.games.each do |game|
        logger.info("#{event.name} : #{slot.name} : #{game.owner.display_name}")
        if gms.include?game.user
          unlocked_achievement = UnlockedAchievement.where(:user_id =>game.user.id, :achievement_id => 1).first
          if unlocked_achievement
            unlocked_achievement.level += 1
            unlocked_achievement.save!
            UserNotifier.achievement_leveled_notice(achievement, game.user).deliver
            logger.info "Level up: #{game.user.display_name}"
          else
            logger.info "nil unlocked_achievement: #{game.user.display_name}"
          end
        else
          gms << game.user
          logger.info "Adding to gms: #{game.user.display_name}"
        end
      end
    end
  end

end
