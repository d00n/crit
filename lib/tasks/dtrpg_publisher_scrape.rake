task :dtrpg_publisher_scrape => :environment do
  require 'nokogiri'
  require 'dtrpg_publisher'
  
  logger = Logger.new('log/rake_dtrpg_publisher_scrape.log')
  logger.info "#{Time.now} Scrape DriveThruRPG for publisher details"
  
  User.publisher.each do |p|
    dtrpg_publisher.scrape(p.dtrpg_id)
#    save_me = false
#
#    mid = p.dtrpg_id.to_s
#    logger.info ""
#    logger.info "p.id: #{p.id}, mid: #{mid}, name: #{p.publisher_name}"
#
#    if mid.blank?
#      logger.info "skipping blank dtrpg_id"
#      next
#    end
#
#    publisher_profile_page = Nokogiri::HTML(open(configatron.DTRPG_PUBLISHER_URL + mid))
#
#    begin
#      homepage_anchor = publisher_profile_page.css('a[text()="Publisher Homepage"]')
#
#      if homepage_anchor.empty?
##        logger.info "No homepage anchor"
#      elsif homepage_anchor.count > 1
#        logger.info "More than one homepage_anchor"
#      else
#        homepage_href = homepage_anchor.last.attributes["href"].value
#        logger.info "homepage_href: #{homepage_href}"
#        p.vendor_url = homepage_href
#        save_me = true
#      end
#
#    rescue
#      logger.error "rescue homepage lookup: #{$!}"
#    end
#
#    begin
#      img = publisher_profile_page.xpath("//img[@alt=\"#{p.publisher_name}\"][@title=\"#{p.publisher_name}\"]")
#
#      if img.empty?
##        logger.info "No logo img"
#        # Don't care, it's labelled the same, and used more than once.
##      elsif img.count > 1
##        logger.info "More than one img"
#      else
#        logo_src = img.last.attributes["src"].value
#
#        if logo_src.end_with?("spacer.gif") ||
#            logo_src.end_with?("drivethurlogo-140.jpg") ||
#            logo_src.end_with?("no_image.jpg") ||
#            logo_src.end_with?("no_image-140.jpg") ||
#            logo_src.end_with?("noimage.jpg")
#          logo_src = ''
#        end
#
#        logger.info "logo_src: #{logo_src}"
#
#        if !logo_src.blank?
#          p.dtrpg_logo = logo_src
#          save_me = true
#        end
#      end
#
#    rescue
#      logger.error "rescue logo lookup: #{$!}"
#    end
#
#    if save_me
#      p.save!
#    end

  end
end
