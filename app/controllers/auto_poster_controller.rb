#class AutoPosterController < BaseController
#require 'rubygems'
#require 'syndication/rss'
#require 'syndication/content'
#require 'open-uri'
#
#
#  def pull_feeds
#    Rails.logger.info 'AutoPoster: starting'
#
#    publishers = User.active.has_blog_rss_url.publisher
#
#    publishers.each do |publisher|
#      Rails.logger.info 'AutoPoster: publisher_name: ' + publisher.publisher_name
#
#      parser = Syndication::RSS::Parser.new
#      feed = parser.parse(open(publisher.blog_rss_url).read)
#
#      feed.items.each do |item|
#        Rails.logger.info 'AutoPoster: item.title: ' + item.title
#
#        post_exists = publisher.posts.find_by_title(item.title)
#
#        if !post_exists.empty?
#          Rails.logger.info 'AutoPoster: post exists, skipping'
#        else
#          Rails.logger.info 'AutoPoster: new post!'
#          post = Post.new()
#          post.user = publisher
#          post.published_as = 'live'
#          post.title = item.title
#          post.published_at = item.pubdate
#
#          if !item.content_decoded.nil?
#            post.raw_post = item.content_decoded.gsub(/\n?/, '').sub(/<div class="feedflare">.*/, '')
#          else
#            post.raw_post = item.description
#          end
#
#          if !item.category.nil?
#            tag_list = ''
#            item.category.each do |category|
#              tag_list += category + ', '
#            end
#            post.tag_list = tag_list
#          end
#
#
#          if post.save
#            Rails.logger.info 'AutoPoster: new post save success'
#          else
#            Rails.logger.info 'AutoPoster: new post save fail'
#          end
#
#        end
#      end
#    end
#
#  end
#
#end
#
#
