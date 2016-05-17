class CommentsController < BaseController
  require_from_ce('controllers/comments_controller')

  #def create
  #  #@commentable = comment_type.constantize.find(comment_id)
  #  #@commentable = comment_type.classify.find(comment_id)
  #
  #  commentable_type = get_commentable_type(params[:commentable_type])
  #  @commentable = commentable_type.singularize.constantize.find(params[:commentable_id])
  #
  #  @comment = @commentable.comments.new(comment_params)
  #
  #  #@comment.commentable = @commentable
  #  @comment.recipient = @commentable.owner
  #  @comment.user_id = current_user.id if current_user
  #  @comment.author_ip = request.remote_ip #save the ip address for everyone, just because
  #
  #  # Moving back to the default CE FB pattern of creating this object in app/views/comments/create.js.rjs
  #  if FACEBOOK_CONNECT && false
  #    fp = FacebookPublisher.create_comment_created(@comment, commentable_url(@comment))
  #    @fp_json = ActiveSupport::JSON.encode(fp)
  #
  #    # staging test value
  #    #@fp_json = '{"attachment": {"href": "http://staging.infrno.net/skipper#comment_", "name": "James Meier, a user on Infrno.net", "description": "o909990", "media": [{"type": "image", "src": "http://staging.infrno.net/photos/0000/1133/1269983106783_thumb.jpg", "href": "http://staging.infrno.net/skipper#comment_"}], "properties": {"tags": {"href": "http://staging.infrno.net/skipper#comment_", "text": "D&D 35, D&D 4e,Warhammer Fantasy, Traveller, CthulhuTech, mouse guard"}}}, "action_links": null, "user_message": "left a comment on Infrno.net", "target": {"friends": null, "hometown_location": null, "session": {"session_key": "2.lUYq4t5cETRgLzgVgXN0tg__.3600.1289534400-100001574959518", "expires": 0, "api_key":"a2cf6e94b330f369e2e5e91c67cd66e8", "uid": 100001574959518, "secret_key": "0fe93e2d6ea19e1be5e155b37066a5c3", "secret_from_session": null, "auth_token": null, "batch_request": null}, "populated": false, "uid": 100001574959518, "id": null, "current_location": null, "pic": null}}'
  #    #@fp_json = '{"attachment": {"href": "http://staging.infrno.net/skipper#comment_", "name": "James Meier, a user on Infrno.net", "description": "44444444", "media": [{"type": "image", "src": "http://staging.infrno.net/photos/0000/1133/1269983106783_thumb.jpg", "href": "http://staging.infrno.net/skipper#comment_"}], "properties": {"tags": {"href": "http://staging.infrno.net/skipper#comment_", "text": "D&D 35, D&D 4e, Warhammer Fantasy, Traveller, CthulhuTech, mouse guard"}}}, "action_links": null, "user_message": "left a comment on Infrno.net", "target": {"friends": null, "hometown_location": null, "session": {"session_key": "2.lUYq4t5cETRgLzgVgXN0tg__.3600.1289534400-100001574959518", "expires": 0, "api_key": "a2cf6e94b330f369e2e5e91c67cd66e8", "uid": 100001574959518, "secret_key": "0fe93e2d6ea19e1be5e155b37066a5c3", "secret_from_session": null, "auth_token": null, "batch_request": null}, "populated": false, "uid": 100001574959518, "id": null, "current_location": null, "pic": null}}'
  #    #@fp_json = "{'attachment': {'href': 'http://staging.infrno.net/skipper#comment_', 'name': 'James Meier, a user on Infrno.net', 'description': '44444444', 'media': [{'type': 'image', 'src': 'http://staging.infrno.net/photos/0000/1133/1269983106783_thumb.jpg', 'href': 'http://staging.infrno.net/photos/0000/1133/1269983106783_thumb.jpg'}], 'properties': {'tags': {'href': 'http://staging.infrno.net/skipper#comment_', 'text': 'D&D 35, D&D 4e, Warhammer Fantasy, Traveller, CthulhuTech, mouse guard'}}}, 'action_links': null, 'user_message': 'left a comment on Infrno.net', 'target': {'friends': null, 'hometown_location': null, 'session': {'session_key': '2.lUYq4t5cETRgLzgVgXN0tg__.3600.1289534400-100001574959518', 'expires': 0, 'api_key': 'a2cf6e94b330f369e2e5e91c67cd66e8', 'uid': 100001574959518, 'secret_key': '0fe93e2d6ea19e1be5e155b37066a5c3', 'secret_from_session': null, 'auth_token': null, 'batch_request': null}, 'populated': false, 'uid': 100001574959518, 'id': null, 'current_location': null, 'pic': null}}"
  #
  #    #href = "http://staging.infrno.net/photos/0000/1133/1269983106783_thumb.jpg"
  #    #src = "http://staging.infrno.net/skipper#comment_"
  #    #media = '"media": [{"type":"image", "href":"'+href+'", "src":"'+src+'"}], '
  #
  #    logger.info("CommentsController.create fp= " + fp.inspect)
  #    logger.info("CommentsController.create fp_json= " + @fp_json)
  #
  #    #@fp_json.insert(16, media)
  #    #logger.info("CommentsController.create fp_json= " + @fp_json)
  #  end
  #
  #  respond_to do |format|
  #    if (logged_in? || verify_recaptcha(@comment)) && @comment.save
  #      @comment.send_notifications
  #
  #      flash.now[:notice] = :comment_was_successfully_created.l
  #      format.html { redirect_to commentable_url(@comment) }
  #      format.js
  #    else
  #      flash.now[:error] = :comment_save_error.l_with_args(:error => @comment.errors.full_messages.to_sentence)
  #      format.html { redirect_to :controller => comment_type.underscore.pluralize, :action => 'show', :id => comment_id }
  #      format.js
  #    end
  #  end
  #end

  def index
    #begin
    #  #@commentable = comment_type.constantize.find(comment_id)
    #  #@commentable = comment_type.classify.find(comment_id)
    #
    #  commentable_type = get_commentable_type(params[:commentable_type])
    #  commentable_class = commentable_type.singularize.constantize
    #  commentable_type_humanized = commentable_type.humanize
    #  commentable_type_tableized = commentable_type.tableize
    #
    #  @commentable = commentable_class.find(params[:commentable_id])
    #
    #rescue
    #  render :nothing => true
    #  return
    #end

    begin

      commentable_type = get_commentable_type(params[:commentable_type])
      commentable_class = commentable_type.singularize.constantize
      commentable_type_humanized = commentable_type.humanize
      commentable_type_tableized = commentable_type.tableize

      @commentable = commentable_class.find(params[:commentable_id])
      #don't use the get_type, as we want the specific case where the user typed /User/username/comments
      redirect_to user_comments_path(params[:commentable_id]) and return if (params[:commentable_type] && params[:commentable_type].camelize == "User")

      unless logged_in? || @commentable && (!@commentable.owner.nil? && @commentable.owner.profile_public?)
        flash.now[:error] = :this_users_profile_is_not_public_youll_need_to_create_an_account_and_log_in_to_access_it.l
        redirect_to :controller => 'sessions', :action => 'new' and return
      end

      if @commentable

        @comments = @commentable.comments.recent.page(params[:page]).per(100)

        if @comments.to_a.empty?

          if  (commentable_type != "User")
            render :text => :no_comments_found.l_with_args(:type => commentable_type.constantize)
            return
          end

          if commentable_type == "User"
            @user = @commentable
            @title = @user.login
            @back_url = user_path(@user)
          else commentable_type != "User"
          @user = @commentable.user
          @title = comment_title
          @back_url = url_for([@user, @commentable].compact)
          end

        else
          @user = @comments.first.recipient
          @title = comment_title
          @back_url = commentable_url(@comments.first)
        end

        respond_to do |format|
          format.html {
            render :action => 'index' and return
          }
          format.rss {
            # @rss_title = "#{configatron.community_name}: #{@commentable.class.to_s.underscore.capitalize} Comments - #{@title}"
            #@rss_url = comment_rss_link
            #render_comments_rss_feed_for([], @commentable, @rss_title) and return
            # render :nothing => true, :status => 404
            redirect_to home_url
            return
          }
        end
      end

      respond_to do |format|
        format.html {
          flash[:notice] = :no_comments_found.l_with_args(:type => comment_type.constantize)
          redirect_to :controller => 'base', :action => 'site_index' and return
        }
      end

    rescue
      redirect_to home_url
      # render :nothing => true, :status => 404
      # return
    end
  end  

  private

    def comment_title
    return @comments.first.commentable_name if @comments.first
  
    type = comment_type.underscore
    case type
      when 'user'
        @commentable.display_name
      when 'post'
        @commentable.title
      when 'clipping'
        @commentable.description || :clipping_from_user.l(@user.display_name)
      when 'photo'
        #@commentable.description || :photo_from_user.l(@user.display_name)
        :photo_from_user.l(@user.display_name)
      else 
        @commentable.class.to_s.humanize
    end  
  end
  


end
