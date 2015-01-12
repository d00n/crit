class SitemapController < BaseController

  def index
    #@users = User.active.last(20)
    #@characters = Character.last(20)
    #@games = Game.last(20)
    #@posts = Post.last(20)
    #@publishers = User.publisher.last(20)
    #@products = Product.last(20)


    respond_to do |format|
      format.html {
        render :layout => 'application'
      }
      format.xml 
    end
  end
  
  
  
end
