task :wizards_isbn_scrape => :environment do
  require 'nokogiri'
  require 'asin'

  logger = Logger.new('log/rake_wizards_product_scrape.log')
  logger.info "#{Time.now}"

  product_index_url = 'http://www.wizards.com/dnd/Catalog.aspx?page='
  product_url = 'http://www.wizards.com/dnd/'
  #publisher = User.find(configatron.WIZARDS_USER_ID)
  publisher = User.find(21612)

  asin_client = ASIN::Client.instance

  for i in 1..30
    logger.info "pass: #{i}"

    product_index_page_url = product_index_url + i.to_s
    logger.info "loading: #{ product_index_page_url }"
    begin
      product_index_page = Nokogiri::HTML(open(product_index_page_url))
    rescue
      logger.error "rescue product index page load: #{$!}"
      next
    end

    begin
      product_list = product_index_page.xpath("//td[@class='Column1']")
    rescue
      logger.error "rescue product index list lookup: #{$!}"
    end

    product_list.each do |product_list|
      begin
        product_path = product_list.children.first.next['href']
      rescue
        logger.error "rescue product href lookup: #{$!}"
        next
      end

      product_page_url = product_url + product_path
      logger.info "loading: #{ product_page_url }"
      begin
        product_page = Nokogiri::HTML(open(product_page_url))
        #logger.info "product_page.class: #{ product_page.class }"
      rescue
        logger.error "rescue product page load: #{$!}"
        next
      end

      begin
        product_info = product_page.xpath("//div[@class='ProductInfo']")
        #logger.info "product_info.class: #{ product_info.class }"
      rescue
        logger.error "rescue product_info lookup: #{$!}"
        next
      end

      product_info_text = product_info.text
      #logger.info "product_info_text : #{product_info_text}"

      isbn_re = /.*ISBN: *(.*) */
      begin
        matches = isbn_re.match(product_info_text)
        isbn = matches.captures[0].strip
        logger.info "found isbn: #{isbn}"
      rescue
        #logger.error "rescue isbn lookup: #{$!}"
        next
      end

      product = Product.find_by_isbn(isbn)
      if product.nil?
        product = Product.new
        product.isbn = isbn
        product.name = 'Unnamed'
        product.save!
        publisher.products << product
      end

      isbn_wo_dashes = isbn.gsub('-', '')
      results = asin_client.lookup_book_from_isbn(isbn_wo_dashes)
      if results.any?
        result = results.first
        books = asin_client.lookup(result.asin)

        if books.any?
          book = books.first
          logger.info "name: #{book.title}"
          logger.info "price: #{book.amount}"
          logger.info "asin: #{book.asin}"
          logger.info "image url: #{book.image_url}"
          logger.info "details url: #{book.details_url}"

          product.name = book.title
          product.description = book.review
          product.price = book.amount
          product.amazon_asin = book.asin
          product.amazon_image_url = book.image_url
          product.purchase_book_url = book.details_url
          product.save!
        else
          logger.error "lookup by asin returned empty"
        end
      else
        logger.error "lookup by isbn returned empty"
      end

      logger.info ""
    end
  end
end
