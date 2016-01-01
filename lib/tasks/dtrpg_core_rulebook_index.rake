task :dtrpg_core_rulebook_index => :environment do
  require 'csv'
  require 'nokogiri'
  require 'dtrpg_publisher'

  logger = Logger.new('log/rake_dtrpg_core_rulebook_index.log')
  logger.info "#{Time.now}"

  index_url = "http://rpg.drivethrustuff.com/index.php?filters=0_2140_0_0_0"

  begin
    index_page = Nokogiri::HTML(open(index_url))
  rescue
    logger.error "rescue index page load: #{$!}"
    next
  end

  doc = index_page.xpath('//form[@name="pageskipform"]')
  pages = doc.first.children.first.next.children.last.attributes.first[1].value.to_i

  for i in 1..pages
    begin
      result_page_url = index_url + '&page=' + i.to_s
      logger.info "loading: #{result_page_url}"
      result_page = Nokogiri::HTML(open(index_url + '&page=' + i.to_s))
    rescue
      logger.error "rescue product index page load: #{$!}"
    end


    begin
      product_listing_table = result_page.xpath("//table[@class='productListing']")
    rescue
      logger.error "rescue product listing table lookup: #{$!}"
    end

    #product_listing = product_listing_table.children.first.next  .children.first.children.first.attributes["href"].content
    product_listing = product_listing_table.children.first.next

    while product_listing

      begin
        product_url = product_listing.children.first.children.first.attributes["href"].content
        logger.info "product url: #{product_url}"
      rescue
        # This can be caused by adult content listings, which are hidden from non-logged-in users
        logger.error "rescue product url: #{$!}"
      end

      begin
        /.*\/product\/(\d+).*/.match(product_url)
        product_id = $1
        logger.info "product_id: #{product_id}"

        product = Product.find_by_dtrpg_product_id(product_id)
        if product.nil?
          # For unknown products:
          # -make sure we have the publisher,
          # -let dtrpg_publisher_product_index pick up the new product later

          logger.info "unknown product, product_id: #{product_id}"

          publisher_url = product_listing.children.first.next.next.children.first.attributes["href"].content
          logger.info "publisher_url: #{publisher_url}"

          /.*manufacturers_id=(\d+).*/.match(publisher_url)
          publisher_id = $1
          logger.info "publisher_id: #{publisher_id}"

          publisher = User.find_by_dtrpg_id(publisher_id)
          if publisher.nil?
            publisher_name = product_listing.children.first.next.next.children.first.children.text
            logger.info "new publisher, name: #{publisher_name}"

            DtrpgPublisher.create(publisher_id, publisher_name, logger)
            DtrpgPublisher.scrape(publisher_id, logger)
            #publisher = User.find_by_dtrpg_id(publisher_id)
          else
            logger.info "existing publisher with unknown product, publisher_id: #{publisher_id}"
            logger.info "existing publisher with unknown product, product_id: #{product_id}"
          end
        else
          product.is_core_rulebook = true
          product.save!
        end

      rescue
        logger.error "rescue 'while product_listing': #{$!}"
      end

      product_listing = product_listing.next
   end

  end
end
