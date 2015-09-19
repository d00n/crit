class FriendshipsController < BaseController
  require_from_ce('controllers/friendships_controller')
  include ActionView::Helpers::JavaScriptHelper

  def create
    @user = User.find(params[:user_id])
    @friendship = Friendship.new(:user_id => params[:user_id], :friend_id => params[:friend_id], :initiator => true )
    @friendship.friendship_status_id = FriendshipStatus[:pending].id
    reverse_friendship = Friendship.new
    reverse_friendship.friendship_status_id = FriendshipStatus[:pending].id
    reverse_friendship.user_id, reverse_friendship.friend_id = @friendship.friend_id, @friendship.user_id

    respond_to do |format|
      if @friendship.save && reverse_friendship.save
        UserNotifier.friendship_request(@friendship).deliver if @friendship.friend.notify_friend_requests?
        format.html {
          flash[:notice] = :friendship_requested.l_with_args(:friend => @friendship.friend.login)
          redirect_to accepted_user_friendships_path(@user)
        }
        format.js {@text = "#{:requested_friendship_with.l} #{@friendship.friend.login}."}
      else
        flash.now[:error] = :friendship_could_not_be_created.l
        flash.now[:error] = @friendship.errors.full_messages
        format.html { redirect_to user_friendships_path(@user) }
        if @friendship.errors.full_messages
          format.js {@text =  escape_javascript(@friendship.errors.full_messages.first) }
        else
          format.js {@text = "#{:friendship_request_failed.l}."}
        end
      end
    end

    friend = User.find(params[:friend_id])
    if friend.publisher?
      @friendship.update_attributes(:friendship_status => FriendshipStatus[:accepted])
      @friendship.reverse.update_attributes(:friendship_status => FriendshipStatus[:accepted])
    end

  end
    
end