task :dtrpg_products_to_categories_import => :environment do
  require 'csv'
  require 'uri'

  logger = Logger.new('log/rake_dtrpg_products_to_categories_import.log')
  logger.info "#{Time.now}"

  def UrlAvailable?(urlStr)
    url = URI.parse(urlStr)
    Net::HTTP.start(url.host, url.port) do |http|
      return http.head(url.request_uri).code == "200"
    end
  end


  CSV.foreach('db/dtrpg_products_to_categories.csv') do |row|
    if row[0] == 'products_id'
      logger.info "skipping header row"
      next
    end

    dtrpg_product_id = row[0]
    dtrpg_category_id = row[1]

    product = Product.find_by_dtrpg_product_id(dtrpg_product_id)
    category = SystemCategory.find_by_dtrpg_category_id(dtrpg_category_id)

    if !category
      logger.error "missing category: #{dtrpg_category_id}"
    elsif !product
      logger.error "missing product: #{dtrpg_product_id}"
    else
      category.products << product

      begin
        if category.save!
          logger.info "success: #{category.id},#{category.name},#{product.name}"
        else
          logger.info "failure: #{category.id},#{category.name},#{product.name}"
        end
      rescue
        logger.error "rescue: #{category.id},#{category.name},#{product.name}"
      end

    end

  end




end
