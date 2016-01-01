task :dtrpg_product_scrape => :environment do
  require 'nokogiri'
  
  logger = Logger.new('log/rake_dtrpg_product_scrape.log')
  logger.info "#{Time.now}"

  i = 0
  Product.dtrpg_stale.each do |product|
    i += 1
    logger.info "pass: #{i}"

    if product.nil? || product.dtrpg_product_id.blank?
      logger.info "skipping missing or non-dtrpg product, id: #{product.id}"
      next
    end

    logger.info "product: #{product.id}, #{product.name}"
    logger.info "updated_at: #{product.updated_at}"

    product_profile_url = configatron.DTRPG_PRODUCT_URL + product.dtrpg_product_id.to_s
    logger.info "loading: #{ product_profile_url }"

    begin
      product_profile = Nokogiri::HTML(open(product_profile_url))
    rescue
      logger.error "rescue product profile page load: #{$!}"
      next
    end

    begin
      product_description_div = product_profile.xpath("//div[@class='grid_11 alpha omega prod-content-content']")
      #logger.info "product_description_div size: #{product_description_div}"
      product_description = product_description_div.children[1..product_description_div.children.size-1].to_s
      logger.info "product_description size: #{product_description.size}"
      product.description = product_description
    rescue
      #logger.error "rescue product description lookup: #{$!}"
    end

    begin
      artists_div = product_profile.search "[text()*='Artist(s)']"
      artists = artists_div.first.next_element.text.strip
      logger.info "artists: #{artists}"
      product.dtrpg_artists = artists
    rescue
      #logger.error "rescue artists lookup: #{$!}"
    end

    begin
      authors_div = product_profile.search "[text()*='Author(s)']"
      authors = authors_div.first.next_element.text.strip
      logger.info "authors: #{authors}"
      product.dtrpg_authors = authors
    rescue
      #logger.error "rescue authors lookup: #{$!}"
    end

    begin
      isbn_div = product_profile.search "[text()*='ISBN']"
      isbn = isbn_div.first.next_element.child.text.strip
      logger.info "isbn: #{isbn}"
      product.isbn = isbn
    rescue
      #logger.error "rescue isbn lookup: #{$!}"
    end

    #begin
    #  rule_system_div = product_profile.search "[text()*='Rule System(s)']"
    #  rule_system= rule_system_div.first.next_element.text.strip
    #  logger.info "rule_system: #{rule_system}"
    #  product.rule_system = rule_system
    #rescue
    #  logger.error "rescue rule_system lookup: #{$!}"
    #end

    product.save!
    logger.info ""
  end
end
