task :create_non_dtrpg_publishers => :environment do

  #logger = Logger.new('log/rake_create_non_dtrpg_publishers.log')
  #logger.info "#{Time.now}"
  puts('rake create_non_dtrpg_publishers')

  def create(login, publisher_name)

    u = User.find_by_login(login)
    if u
      #logger.info "create() skipping existing record for login= #{login}"
      puts "create() skipping existing record for login= #{login}"
    else

      sanitized_name = publisher_name.gsub(/[^A-Za-z0-9]/, ' ')
      sanitized_name.gsub!(/ +/, '-')
      sanitized_name.gsub!(/-+$/, '')
      sanitized_name.gsub!(/^-+/, '')

      password = "IgniteTheWorld_8"
      login = User.create_unique_login(sanitized_name)

      additional_skids = 5 - login.length
      additional_skids.times do
        login += '_'
      end

      u = User.new({:birthday => Date.parse((Time.now - 25.years).to_s) })
      u.publisher = true
      u.publisher_name = publisher_name
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

          #logger.info "create() success: #{publisher_name}"
          puts "create() success: #{publisher_name}"
        else
          #logger.info "create() failure: #{publisher_name}"
          puts "create() failure: #{publisher_name}"
        end
      rescue
        #logger.info "rescue: #{publisher_name}"
        puts "rescue: #{publisher_name}, #{$!.to_s}"
      end
    end
  end


  create('paizo','Paizo')
  create('TSR','TSR')



end
