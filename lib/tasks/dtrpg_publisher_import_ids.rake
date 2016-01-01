task :dtrpg_publisher_import_ids => :environment do
  require 'csv'

  logger = Logger.new('log/rake_dtrpg_publisher_import_ids.log')
  logger.info "#{Time.now}"

  kieara = User.find(5)

  CSV.foreach('db/dtrpg_publishers.csv') do |row|
    if row[0] == 'id'
      logger.info "skipping header row"
      next
    end

    dtrpg_id = row[0]

    u = User.find_by_dtrpg_id(dtrpg_id)
    if u
      #logger.info "skipping existing record for dtrpg_id= #{dtrpg_id}, row[1]=#{row[1]}, u.name=#{u.publisher_name}"
      logger.info ""
      logger.info "skipping existing record for dtrpg_id= #{dtrpg_id}"
      logger.info "u.name=#{u.publisher_name}"
    else

      publisher_name = row[1]
      sanitized_name = publisher_name.gsub(/[^A-Za-z0-9]/, ' ')
      sanitized_name.gsub!(/ +/, '-')
      sanitized_name.gsub!(/-+$/, '')
      sanitized_name.gsub!(/^-+/, '')

      password = "IgniteTheWorld_" + dtrpg_id
      login = User.create_unique_login(sanitized_name)

      additional_skids = 5 - login.length
      additional_skids.times do
        login += '_'
      end

      u = User.new({:birthday => Date.parse((Time.now - 25.years).to_s) })
      u.publisher = true
      u.publisher_name = publisher_name
      u.dtrpg_id = Integer(dtrpg_id)
      u.login = login
      u.login_slug = login
      u.email = "#{login}@infrno.net"
      u.password = password
      u.password_confirmation = password
      u.role = Role[:member]
      u.activated_at = Time.now
      u.last_request_at = Time.now

      begin
        if u.save!
          make_slug = User.find(u.id)
          make_slug.save!

          logger.info "success: #{u.id},#{u.dtrpg_id},#{u.login},#{make_slug.login_slug}"
        else
          logger.info "failure: #{u.id},#{u.dtrpg_id},#{u.login},#{make_slug.login_slug}"
        end
      rescue
        logger.info "rescue: #{u.id},#{u.dtrpg_id},#{u.publisher_name}, #{$!.to_s}"
      end
    end

    if kieara && u.can_request_friendship_with(kieara)
      accepted    = FriendshipStatus[:accepted]

      friendship = Friendship.new(:user_id => kieara.id,
                                   :friend_id => u.id,
                                   :friendship_status => accepted,
                                   :initiator => true)

      reverse_friendship = Friendship.new(:user_id => u.id,
                                          :friend_id => kieara.id,
                                          :friendship_status => accepted )

      friendship.save
      reverse_friendship.save
    end

  end




end
