class AutoPosterController < BaseController
require 'rubygems'
require 'syndication/rss'
require 'syndication/content'
require 'open-uri'


  def pull_catalog
  
    catalog_url = 'http://rpg.drivethrustuff.com/index.php?manufacturers_id=2216'

    open(catalog_url, 
      "User-Agent" => "Infrno",
      "From" => "catalog_crawler@infrno.net") { |f|
        puts "Fetched document: #{f.base_uri}"
        puts "\\t Content Type: #{f.content_type}\\n"
        puts "\\t Charset: #{f.charset}\\n"
        puts "\\t Content-Encoding: #{f.content_encoding}\\n"
        puts "\\t Last Modified: #{f.last_modified}\\n\\n"
 
        # Save the response body
        @response = f.read
      }

    
  end
  
end


