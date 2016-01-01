task :dtrpg_categories_import => :environment do
  require 'csv'
  require 'uri'

  logger = Logger.new('log/rake_dtrpg_categories_import.log')
  logger.info "#{Time.now}"

  def UrlAvailable?(urlStr)
    url = URI.parse(urlStr)
    Net::HTTP.start(url.host, url.port) do |http|
      return http.head(url.request_uri).code == "200"
    end
  end


  CSV.foreach('db/dtrpg_categories.csv') do |row|
    if row[0] == 'categories_id'
      logger.info "skipping header row"
      next
    end

    dtrpg_category_id = row[0]
    dtrpg_category_image = row[1]
    dtrpg_parent_category_id = row[2]
    category_name = row[3]


    category = SystemCategory.find_by_dtrpg_category_id(dtrpg_category_id)
    if !category
      category = SystemCategory.new()
    end

    category.name = category_name
    category.dtrpg_category_id = dtrpg_category_id
    category.dtrpg_parent_category_id = dtrpg_parent_category_id

    image_url = configatron.DTRPG_IMAGE + dtrpg_category_image
    image_url.gsub!(' ', '%20')

    if dtrpg_category_image != 'NULL' && dtrpg_category_image != 'no_image.jpg' && UrlAvailable?(image_url)
      category.dtrpg_category_image = dtrpg_category_image
    else
      logger.info "nilling dtrpg_category_image for: #{category.dtrpg_category_id},#{image_url}"
      category.dtrpg_category_image = nil
    end

    begin
      if category.save!

        make_slug = SystemCategory.find_by_dtrpg_category_id(dtrpg_category_id)
        make_slug.save!

        logger.info "success: #{category.id},#{category.dtrpg_category_id},#{category.name},#{make_slug.name_slug}"
      else
        logger.info "failure: #{category.id},#{category.dtrpg_category_id},#{category.name},#{make_slug.name_slug}"
      end
    rescue
      logger.info "rescue: #{category.id},#{category.dtrpg_category_id},#{category.name}"
    end


  end




end
