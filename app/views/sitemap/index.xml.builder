xml.instruct!
 
xml.urlset "xmlns" => "http://www.google.com/schemas/sitemap/0.84" do
  xml.url do
    xml.loc         "#{home_url}"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "hourly"
  end

  #@users.each do |user|
  #  xml.url do
  #    xml.loc        user_url user
  #    xml.lastmod     w3c_date(user.updated_at ||  Time.now)
  #    xml.changefreq  "weekly"
  #    xml.priority    0.7
  #  end
  #end
  #
  #@characters.each do |character|
  #  xml.url do
  #    xml.loc         character_url character.id
  #    xml.lastmod     w3c_date(character.updated_at ||  Time.now)
  #    xml.changefreq  "weekly"
  #    xml.priority    0.7
  #  end
  #end
  #
  #@publishers.each do |publisher|
  #  xml.url do
  #    xml.loc         publisher_url publisher
  #    xml.lastmod     w3c_date(publisher.updated_at ||  Time.now)
  #    xml.changefreq  "weekly"
  #    xml.priority    0.7
  #  end
  #end
  #
  #@products.each do |product|
  #  xml.url do
  #    xml.loc         publisher_product_url product.owner, product
  #    xml.lastmod     w3c_date(product.updated_at ||  Time.now)
  #    xml.changefreq  "weekly"
  #    xml.priority    0.7
  #  end
  #end
  #
  #@games.each do |game|
  #  xml.url do
  #    xml.loc         game_url game.id
  #    xml.lastmod     w3c_date(game.updated_at ||  Time.now)
  #    xml.changefreq  "weekly"
  #    xml.priority    0.7
  #  end
  #end
  #
  #
  #
  #
  #@posts.each do |post|
  #  xml.url do
  #    xml.loc         user_post_url post.user, post
  #    xml.lastmod     w3c_date(post.published_at)
  #    xml.changefreq  "weekly"
  #    xml.priority    0.6
  #  end
  #end

  

end
