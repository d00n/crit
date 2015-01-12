class SbPostsController < BaseController

  protected
    #overide in your app
    def authorized?
      # I added edit, update, index and destroy, because recent, rss, edit, and deltee were bombing
      # No idea what sort of security issue that may be
      %w(create new edit update index destroy).include?(action_name) || @post.editable_by?(current_user)
    end
    
end
