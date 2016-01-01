task :dtrpg_publisher_product_index => :environment do
  require 'csv'
  require 'nokogiri'

  logger = Logger.new('log/rake_dtrpg_publisher_product_index.log')
  logger.info "#{Time.now}"


   #product_profile_url = 'http://rpg.drivethrustuff.com/product_info.php?products_id='
#  product_id = "3330"
#  product_detail = Nokogiri::HTML(open(product_profile_url + product_id))
#  product_description = product_detail.xpath("//h2[text()='Description']")
#  logger.info "product id: #{product_id}"
#  logger.info "product_description #{product_description.first.parent.to_s}"


  product_index_url = 'http://rpg.drivethrustuff.com/remote.php?cols=1&price=5&free=1&mid='

  i = 0
  User.publisher_stale.each do |publisher|
    i += 1
    logger.info "pass: #{i}"


    #if publisher.dtrpg_id != 3225
    #  next
    #end

    mid = publisher.dtrpg_id.to_s
    logger.info "publisher.id: #{publisher.id}, mid: #{mid}, name: #{publisher.publisher_name}"
    logger.info "updated_at: #{publisher.updated_at}"

    if mid.blank?
      logger.info "skipping blank dtrpg_id"
      next
    end

    begin
      product_list_page = Nokogiri::HTML(open(product_index_url + mid))
    rescue
      logger.error "rescue product index page load: #{$!}"
    end

    begin
      product_anchors = product_list_page.xpath('//img')
      if product_anchors.empty?
        next
      end
    rescue
      logger.error "rescue product anchor lookup: #{$!}"
    end


    begin
      product_anchors.each do |anchor|
        img_src = anchor.attributes["src"].value
        if img_src.empty?
          logger.info "No img_src found"
          next
        elsif img_src == 'http://rpg.drivethrustuff.com/images/powered.jpg'
          next
        else
          title = anchor.attributes["title"].value
          href = anchor.parent.attributes["href"].value
          price_all = anchor.parent.parent.css('b').text

          price =  price_all.split(' ').first

          if price_all.split(' ').size == 2
           sale_price =  price_all.split(' ').last
          end

          if price == '$0.00'
            price = '<b>FREE!</b>'
          end


          pid_re = /rpg\.drivethrustuff\.com\/product\/([0-9]*)/
          matches = pid_re.match(href)
          dtrpg_product_id = matches.captures[0]

          logger.info "dtrpg_product_id: #{dtrpg_product_id}"
          logger.info "title: #{title}"
          logger.info "href: #{href}"
          logger.info "img_src: #{img_src}"
          logger.info "price: #{price}"
          logger.info "sale_price: #{sale_price}"
          logger.info ""


          product = Product.find_by_dtrpg_product_id(dtrpg_product_id)
          if product.nil?
            product = Product.new
            product.dtrpg_product_id = dtrpg_product_id
          end

          product.name = title
          product.dtrpg_product_image = img_src
          product.dtrpg_price = price
          product.dtrpg_sale_price = sale_price
          publisher.products << product

          product.save!
        end
      end
    rescue
      logger.error "rescue anchor inspection: #{$!}"
    end
  end
end
