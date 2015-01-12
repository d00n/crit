class UserNotifier < ActionMailer::Base
  require_from_ce('models/user_notifier')

  require 'htmlentities'

  def upcoming_game_notification(user)
    setup_email(user)
    @subject  += "Upcoming game reminder"
    @user = user
    mail(:to => @recipients, :subject => @subject)
  end

  def achievement_granted_notice(achievement, user)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Achievement notice"}'

    @recipients  = "#{user.email}"
    @subject     = "Infrno achievement unlocked! #{achievement.name}"
    @sent_on     = Time.now
    @achievement = achievement
    @description = HTMLEntities.new.decode(strip_tags(@achievement.description))
    @user = user
    mail(:to => @recipients, :subject => @subject)
  end

  def achievement_granted_by_non_author_notice(unlocked_achievement, user)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Achievement notice"}'

    @recipients  = "#{user.email}"
    @subject     = "Your Infrno achievement was granted by #{unlocked_achievement.grantor.display_name}"
    @sent_on     = Time.now
    @unlocked_achievement = unlocked_achievement
    @achievement = unlocked_achievement.achievement
    @description = HTMLEntities.new.decode(strip_tags(@achievement.description))
    @user = user
    mail(:to => @recipients, :subject => @subject)
  end

  def achievement_leveled_notice(achievement, user)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Achievement notice"}'

    @recipients  = "#{user.email}"
    @subject     = "Infrno achievement leveled up! #{achievement.name}"
    @sent_on     = Time.now
    @achievement = achievement
    @description = HTMLEntities.new.decode(strip_tags(@achievement.description))
    @user = user
    mail(:to => @recipients, :subject => @subject)
  end

  def achievement_accepted_notice(achievement, user, grantee)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Achievement notice"}'

    @recipients  = "#{user.email}"
    @subject     = "Infrno achievement accepted #{achievement.name}"
    @sent_on     = Time.now
    @achievement = achievement
    @description = HTMLEntities.new.decode(strip_tags(@achievement.description))
    @user = user
    @grantee = grantee
    mail(:to => @recipients, :subject => @subject)
  end

  def achievement_revoked_notice(achievement, user)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Achievement notice"}'

    @recipients  = "#{user.email}"
    @subject     = "Infrno achievement revoked #{achievement.name}"
    @sent_on     = Time.now
    @achievement = achievement
    @description = HTMLEntities.new.decode(strip_tags(@achievement.description))
    @user = user
    mail(:to => @recipients, :subject => @subject)
  end




  def access_violation_notice( attempted_action, request, user = nil)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "access violation report"}'

    @recipients  = "access_violation@infrno.net"
    @attempted_action = attempted_action
    @request     = request
    @subject     = "Infrno access violation"
    @sent_on     = Time.now

    @user_display_name = 'n/a'
    @user_path = 'n/a'
    if user
      @user_display_name = user.display_name
      @user_path = user_path(user)
    end
    mail(:to => @recipients, :subject => @subject)
  end



  def achievement_admin_granted_notice(user)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "achievement admin granted"}'

    @recipients  = "#{user.email}"
    @subject     = "Infrno achievement admin status granted"
    @sent_on     = Time.now
    @user = user
    mail(:to => @recipients, :subject => @subject)
  end

  def achievement_admin_revoked_notice(user)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "achievement admin granted"}'

    @recipients  = "#{user.email}"
    @subject     = "Infrno achievement admin status revoked"
    @sent_on     = Time.now
    @user = user
    mail(:to => @recipients, :subject => @subject)
  end

  def chat_admin_granted_notice(user)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Chat admin granted"}'

    @recipients  = "#{user.email}"
    @subject     = "Infrno chat admin status granted"
    @sent_on     = Time.now
    @user = user
    mail(:to => @recipients, :subject => @subject)
  end

  def chat_admin_revoked_notice(user)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Chat admin granted"}'

    @recipients  = "#{user.email}"
    @subject     = "Infrno chat admin status revoked"
    @sent_on     = Time.now
    @user = user
    mail(:to => @recipients, :subject => @subject)
  end


  def user_premium_granted_notice(user, membership_level_name)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Chat admin granted"}'

    @recipients  = "#{user.email}"
    @subject     = "Infrno premium membership granted"
    @sent_on     = Time.now
    @user = user
    @membership_level_name = membership_level_name
    mail(:to => @recipients, :subject => @subject)
  end

  def user_premium_revoked_notice(user)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Chat admin granted"}'

    @recipients  = "#{user.email}"
    @subject     = "Infrno premium membership revoked"
    @sent_on     = Time.now
    @user = user
    mail(:to => @recipients, :subject => @subject)
  end

  def user_admin_granted_notice(user)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Chat admin granted"}'

    @recipients  = "#{user.email}"
    @subject     = "Infrno user admin status granted"
    @sent_on     = Time.now
    @user = user
    mail(:to => @recipients, :subject => @subject)
  end

  def user_admin_revoked_notice(user)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Chat admin granted"}'

    @recipients  = "#{user.email}"
    @subject     = "Infrno user admin status revoked"
    @sent_on     = Time.now
    @user = user
    mail(:to => @recipients, :subject => @subject)
  end



  def newsletter(subject, message)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Newsletter"}'

    @bcc = []
    User.active.all.each do |user|
      if user.notify_admin_blasts
        @bcc << user.email
      end
    end

    @recipients  = ""
    @subject     = subject
    @body        = message
    @sent_on     = Time.now
    mail(:to => @recipients, :subject => @subject)
  end

  def contact(params, http_user_agent)
    @from       = "Infrno <support@infrno.net>"
    headers     "Reply-to" => "#{params[:contact][:email]}"
    headers     'X-SMTPAPI' => '{"category" : "Feedback"}'

    @recipients  = 'feedback@infrno.net'
    @subject     = "Infrno feedback: " + params[:contact][:subject]
    @sent_on     = Time.now
    @from_name   = params[:contact][:name]
    @from_email  = params[:contact][:email]
    @message = params[:contact][:body]
    @http_user_agent = http_user_agent
    mail(:to => @recipients, :subject => @subject)
  end

  def game_play_kerfuffle(game, msg)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game play error"}'

    @recipients  = 'support@infrno.net'
    @subject     = "Infrno: Game play error for '#{game.name}'"
    @sent_on     = Time.now
    @game = game
    @msg = msg
    mail(:to => @recipients, :subject => @subject)
  end

  def game_table_reset(game, user, old_room_id)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game play error"}'

    @recipients  = 'support@infrno.net'
    @subject     = "Infrno: Game table reset for '#{game.name}'"
    @sent_on     = Time.now
    @game = game
    @user = user
    @old_room_id = old_room_id
    mail(:to => @recipients, :subject => @subject)
  end

  def new_game_notice(game)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "New game notice"}'

    @bcc = []
    User.active.all.each do |user|
      if user.notify_new_games && !user.publisher
        @bcc << user.email
      end
    end

    @recipients  = ""
    @subject     = "Infrno: New game created: #{game.name}"
    @sent_on     = Time.now
    @game = game
    @user = @game.owner
    mail(:to => @recipients, :subject => @subject)
  end

  def game_join_player_notice(game, registration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'

    @recipients  = "#{game.owner.email}"
    @subject     = "Infrno: Application to join your game: #{game.name}"
    @sent_on     = Time.now
    @game = game
    @registration = registration
    @user = @game.owner
    mail(:to => @recipients, :subject => @subject)
  end

  def game_join_alternate_notice(game, registration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'

    @recipients  = "#{game.owner.email}"
    @subject     = "Infrno: Application to join your game: #{game.name}"
    @sent_on     = Time.now
    @game = game
    @registration = registration
    @user = @game.owner
    mail(:to => @recipients, :subject => @subject)
  end

  def game_join_character_notice(game, registration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'

    @recipients  = "#{game.owner.email}"
    @subject     = "Infrno: Application to join your game: #{game.name}"
    @sent_on     = Time.now
    @game = game
    @registration = registration
    @user = @game.owner
    mail(:to => @recipients, :subject => @subject)
  end

  def game_join_player_auto_approved_notice(game, registration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'

    @recipients  = "#{game.owner.email}"
    @subject     = "Infrno: New player registration for #{game.name}"
    @sent_on     = Time.now
    @game = game
    @registration = registration
    @user = @game.owner
    mail(:to => @recipients, :subject => @subject)
  end

  def game_cancel_player_notice(game, registration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'

    @recipients  = "#{game.owner.email}"
    @subject     = "Infrno: Cancelled application to join your game: #{game.name}"
    @sent_on     = Time.now
    @game = game
    @registration = registration
    @user = @game.owner
    mail(:to => @recipients, :subject => @subject)
  end



  #def game_join_pregenerated_notice(game, pregeneratedCharacterRequest)
  #  setup_sender_info
  #  headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'#
  #
  #  @recipients  = "#{game.owner.email}"
  #  @subject     = "Application to join your game: #{game.name}"
  #  @sent_on     = Time.now
  #  @game = game
  #  @pregeneratedCharacterRequest = pregeneratedCharacterRequest
  #  @user = @game.owner
  #  mail(:to => @recipients, :subject => @subject)
  #end

  def game_approve_player_notice(game, registration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'

    @recipients  = "#{registration.user.email}"
    @subject     = "Infrno: Your registration has been approved for #{game.name}"
    @sent_on     = Time.now
    @game = game
    @registration = registration
    @user = @registration.user.owner
    mail(:to => @recipients, :subject => @subject)
  end

  def game_approve_alternate_notice(game, registration, alternate_position)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'

    @recipients  = "#{registration.user.email}"
    @subject     = "Infrno: Your registration as an alternate has been approved for #{game.name}"
    @sent_on     = Time.now
    @game = game
    @registration = registration
    @user = @registration.user.owner
    @alternate_position = alternate_position
    mail(:to => @recipients, :subject => @subject)
  end

  def game_activate_alternate_notice(game, registration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'

    @recipients  = "#{registration.user.email}"
    @subject     = "Infrno Alternate Notice: You are approved for #{game.name}"
    @sent_on     = Time.now
    @game = game
    @registration = registration
    @user = @registration.user.owner
    mail(:to => @recipients, :subject => @subject)
  end

  #def game_approve_character_notice(game, registration)
  #  setup_sender_info
  #  headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'
  #
  #  @recipients  = "#{registration.character.owner.email}"
  #  @subject     = "#{registration.character.name}'s registration has been approved for #{game.name}"
  #  @sent_on     = Time.now
  #  @game = game
  #  @registration = registration
  #  @user = @registration.character.owner
  #  mail(:to => @recipients, :subject => @subject)
  #end

  def game_register_pregenerated_character_notice(game, characterRegistration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'

    @recipients  = "#{game.owner.email}"
    @subject     = "Infrno: #{characterRegistration.character.owner.display_name} has registered a pregen for #{game.name}"
    @sent_on     = Time.now
    @game = game
    @characterRegistration = characterRegistration
    @user = @game.owner
    mail(:to => @recipients, :subject => @subject)
  end

  def game_register_character_notice(game, characterRegistration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'

    @recipients  = "#{game.owner.email}"
    @subject     = "Infrno: #{characterRegistration.character.owner.display_name} has registered a character for #{game.name}"
    @sent_on     = Time.now
    @game = game
    @characterRegistration = characterRegistration
    @user = @game.owner
    mail(:to => @recipients, :subject => @subject)
  end

  def game_deny_player_notice(game, registration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'

    @recipients  = "#{registration.user.email}"
    @subject     = "Infrno: Your registration has been denied for #{game.name}"
    @sent_on     = Time.now
    @game = game
    @registration = registration
    @user = @registration.user.owner
    mail(:to => @recipients, :subject => @subject)
  end

  #def game_deny_character_notice(game, registration)
  #  setup_sender_info
  #  headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'
  #
  #  @recipients  = "#{registration.character.owner.email}"
  #  @subject     = "#{registration.character.name}'s registration has been denied for '#{game.name}'"
  #  @sent_on     = Time.now
  #  @game = game
  #  @registration = registration
  #  @user = @registration.character.owner
  #  mail(:to => @recipients, :subject => @subject)
  #end

  #def game_deny_pregenerated_notice(game, pregeneratedCharacterRequest)
  #  setup_sender_info
  #  headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'
  #
  #  @recipients  = "#{pregeneratedCharacterRequest.owner.email}"
  #  @subject     = "#{pregeneratedCharacterRequest.character.name}'s registration has been denied for #{game.name}"
  #  @sent_on     = Time.now
  #  @game = game
  #  @pregeneratedCharacterRequest = pregeneratedCharacterRequest
  #  @user = @pregeneratedCharacterRequest.owner
  #  mail(:to => @recipients, :subject => @subject)
  #end

  def game_kick_player_notice(game, registration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'

    @recipients  = "#{registration.user.email}"
    @subject     = "Infrno: You have been removed from #{game.name}"
    @sent_on     = Time.now
    @game = game
    @registration = registration
    @user = @registration.user.owner
    mail(:to => @recipients, :subject => @subject)
  end

  def game_kick_alternate_notice(game, registration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'

    @recipients  = "#{registration.user.email}"
    @subject     = "Infrno: You have been removed from #{game.name}"
    @sent_on     = Time.now
    @game = game
    @registration = registration
    @user = @registration.user.owner
    mail(:to => @recipients, :subject => @subject)
  end

  def game_kick_character_notice(game, registration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'

    @recipients  = "#{registration.character.owner.email}"
    @subject     = "Infrno: #{registration.character.name} has been removed from #{game.name}"
    @sent_on     = Time.now
    @game = game
    @registration = registration
    @user = @registration.character.owner
    mail(:to => @recipients, :subject => @subject)
  end

  def game_character_leave_notice(game, characterRegistration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'

    @recipients  = "#{game.owner.email}"
    @subject     = "Infrno: #{characterRegistration.character.name} has left #{game.name}"
    @sent_on     = Time.now
    @game = game
    @registration = characterRegistration
    @user = characterRegistration.game.owner
    mail(:to => @recipients, :subject => @subject)
  end

  def game_player_leave_notice(game, playerRegistration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'

    @recipients  = "#{playerRegistration.game.owner.email}"
    @subject     = "Infrno: #{playerRegistration.user.display_name} has left #{game.name}"
    @sent_on     = Time.now
    @game = game
    @registration = playerRegistration
    @user = playerRegistration.game.owner
    mail(:to => @recipients, :subject => @subject)
  end

  def game_player_leave_and_alternate_activated_notice(game, playerRegistration, alternateRegistration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'

    @recipients  = "#{playerRegistration.game.owner.email}"
    @subject     = "Infrno: A player left, and an alternate has been activated for #{game.name}"
    @sent_on     = Time.now
    @game = game
    @registration = playerRegistration
    @alternateRegistration = alternateRegistration
    @user = playerRegistration.game.owner
    mail(:to => @recipients, :subject => @subject)
  end

  def game_release_alternates_notice(game, registration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Game application notice"}'

    @recipients  = "#{registration.user.email}"
    @subject     = "Infrno Alternate Notice: Game has checked in full, #{game.name}"
    @sent_on     = Time.now
    @game = game
    @registration = registration
    @user = registration.user
    mail(:to => @recipients, :subject => @subject)
  end



  def user_beta_invite(beta_invite)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Beta invitation"}'

    @recipients  = beta_invite.email
    @subject     = "Infrno: Infrno private beta invitation"
    @sent_on     = Time.now
    @beta_invite_code = beta_invite.code
    @inviter_name = beta_invite.inviter_name
    @invitee_name = beta_invite.invitee_name
    mail(:to => @recipients, :subject => @subject)
  end

  def publisher_beta_invite(beta_invite)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Beta invitation"}'

    @recipients  = beta_invite.email
    @subject     = "Infrno vendor account invitation"
    @sent_on     = Time.now
    @beta_invite_code = beta_invite.code
    @inviter_name = beta_invite.inviter_name
    @invitee_name = beta_invite.invitee_name
    mail(:to => @recipients, :subject => @subject)
  end

  # Event registration

  def slot_register_game_notice(slotGameRegistration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Event registration"}'

    @recipients  = "#{slotGameRegistration.slot.event.owner.email}"
    @subject     = "Infrno: #{slotGameRegistration.game.owner.display_name} has registered a game for #{slotGameRegistration.slot.event.name}"
    @sent_on     = Time.now
    @user        = slotGameRegistration.slot.event.owner
    @slotGameRegistration = slotGameRegistration
    mail(:to => @recipients, :subject => @subject)
  end

  def slot_approve_game_notice(slotGameRegistration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Event registration"}'

    @recipients  = "#{slotGameRegistration.game.owner.email}"
    @subject     = "Infrno: Game registration approved for #{slotGameRegistration.slot.event.name}"
    @sent_on     = Time.now
    @user        = slotGameRegistration.game.owner
    @slotGameRegistration = slotGameRegistration
    mail(:to => @recipients, :subject => @subject)
  end

  def slot_deny_game_notice(slotGameRegistration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Event registration"}'

    @recipients  = "#{slotGameRegistration.game.owner.email}"
    @subject     = "Infrno: Game registration denied for #{slotGameRegistration.slot.event.name}"
    @sent_on     = Time.now
    @user        = slotGameRegistration.game.owner
    @slotGameRegistration = slotGameRegistration
    mail(:to => @recipients, :subject => @subject)
  end

  def slot_kick_game_notice(slotGameRegistration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Event registration"}'

    @recipients  = "#{slotGameRegistration.game.owner.email}"
    @subject     = "Infrno: Game registration revoked for #{slotGameRegistration.slot.event.name}"
    @sent_on     = Time.now
    @user        = slotGameRegistration.game.owner
    @slotGameRegistration = slotGameRegistration
    mail(:to => @recipients, :subject => @subject)
  end

  def slot_cancel_game_notice(slotGameRegistration)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Event registration"}'

    @recipients  = "#{slotGameRegistration.slot.event.owner.email}"
    @subject     = "Infrno: Game registration cancelled #{slotGameRegistration.slot.event.name}"
    @sent_on     = Time.now
    @user        = slotGameRegistration.slot.event.owner
    @slotGameRegistration = slotGameRegistration
    mail(:to => @recipients, :subject => @subject)
  end


  ## CE stuff, w mods

  def signup_invitation(email, user, message)
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "User invitation"}'

    @bcc         = "signup_invitation@infrno.net"
    @recipients  = "#{email}"
    @subject     = "#{user.display_name} wants you to become Infrnal!"
    @sent_on     = Time.now
    @user = @body[:user]  = user
    @url = @body[:url]   = signup_by_id_url(user, user.invite_code)
    @message = @body[:message]  = message
    mail(:to => @recipients, :subject => @subject)
  end

  def friendship_request(friendship)
    setup_email(friendship.friend)
    headers     'X-SMTPAPI' => '{"category" : "Friendship request/accept"}'

    @subject     += "#{:would_like_to_be_friends_with_you_on.l(:user => friendship.user.display_name, :site => configatron.community_name)}"
    @url = pending_user_friendships_url(friendship.friend)
    @body[:url]   = pending_user_friendships_url(friendship.friend)
    @requester = friendship.user
    @body[:requester]  = friendship.user
    mail(:to => @recipients, :subject => @subject)
  end

  def friendship_accepted(friendship)
    setup_email(friendship.user)
    headers     'X-SMTPAPI' => '{"category" : "Friendship request/accept"}'

    @subject     += "#{:friendship_request_accepted.l}"
    @requester = friendship.user
    @body[:requester]  = friendship.user
    @friend = friendship.friend
    @body[:friend]     = friendship.friend
    @url =  user_url(friendship.friend)
    @body[:url]        = user_url(friendship.friend)
    mail(:to => @recipients, :subject => @subject)
  end

  def comment_notice(comment)
    setup_email(comment.recipient)
    headers     'X-SMTPAPI' => '{"category" : "Comment notice"}'

    @subject     += "#{:has_something_to_say_to_you_on.l(:user => comment.user.display_name, :site => configatron.community_name)}"
    @url = @body[:url]   = commentable_url(comment)
    @comment = @body[:comment]  = comment
    @commenter = @body[:commenter]  = comment.user
    mail(:to => @recipients, :subject => @subject)
  end

  def follow_up_comment_notice(user, comment)
    setup_email(user)
    headers     'X-SMTPAPI' => '{"category" : "Comment notice"}'

    @subject     += "#{:has_commented_on_something_that_you_also_commented_on.l(:user => comment.user.display_name, :item => comment.commentable_type)}"
    @url = @body[:url]   = commentable_url(comment)
    @comment = @body[:comment]  = comment
    @commenter = @body[:commenter]  = comment.user

    @unsubscribe_link = @body[:unsubscribe_link]  = url_for(:controller => 'comments', :action => 'unsubscribe', :comment_id => comment.id, :token => comment.token_for(user.email), :email => user.email)
    mail(:to => @recipients, :subject => @subject)
  end

  def follow_up_comment_notice_anonymous(email, comment)
    @recipients  = "#{email}"
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Comment notice"}'

    @subject     = "[#{configatron.community_name}] "
    @sent_on     = Time.now
    @subject     += "#{:has_commented_on_something_that_you_also_commented_on.l(:user => comment.user.display_name, :item => comment.commentable_type)}"
    @url = @body[:url]   = commentable_url(comment)
    @comment = @body[:comment]  = comment

    @unsubscribe_link = @body[:unsubscribe_link]  = url_for(:controller => 'comments', :action => 'unsubscribe', :comment_id => comment.id, :token => comment.token_for(email), :email => email)
    mail(:to => @recipients, :subject => @subject)
  end

  def new_forum_post_notice(user, post)
   setup_email(user)
   @user = user
   headers     'X-SMTPAPI' => '{"category" : "New forum post"}'

   @subject     += "#{post.user.display_name} has posted in the forum thread '#{post.topic.title}'"
   @url  = "#{forum_topic_url(:forum_id => post.topic.forum, :id => post.topic, :page => post.topic.last_page)}##{post.dom_id}"
   @post = post
   @author = post.user
   mail(:to => @recipients, :subject => @subject)
 end

  def signup_notification(user)
    setup_email(user)
    headers     'X-SMTPAPI' => '{"category" : "Email confirmation"}'

    @subject    += "#{:please_activate_your_new_account.l(:site => configatron.community_name)}"
    @url = @body[:url]   = "#{home_url}users/activate/#{user.activation_code}"
    mail(:to => @recipients, :subject => @subject)
  end

  def message_notification(message)
    setup_email(message.recipient)
    headers     'X-SMTPAPI' => '{"category" : "Private message notice"}'

    @subject     += "#{:sent_you_a_private_message.l(:user => message.sender.display_name)}"

    @message = message
    mail(:to => @recipients, :subject => @subject)
  end


  def post_recommendation(name, email, post, message = nil, current_user = nil)
    @recipients  = "#{email}"
    @sent_on     = Time.now
    setup_sender_info
    headers     'X-SMTPAPI' => '{"category" : "Post recommendation"}'

    @subject     = "#{name} wants you to check out this story on #{configatron.community_name}: #{post.title}"
    content_type "text/plain"
    @name = @body[:name]  = name
    @title = @body[:title]   = post.title
    @post = @body[:post]  = post
    @signup_link = @body[:signup_link]  = (current_user ?  signup_by_id_url(current_user, current_user.invite_code) : signup_url )
    @message = @body[:message]   = message
    @url = @body[:url]   = user_post_url(post.user, post)
    @description = @body[:description]  = truncate_words(post.post, 100, "...")
    mail(:to => @recipients, :subject => @subject)
  end

  def activation(user)
    setup_email(user)
    headers     'X-SMTPAPI' => '{"category" : "Account activation"}'

    @subject    += "#{:your_account_has_been_activated.l(:site => configatron.community_name)}"
    @url = @body[:url]   = home_url
    mail(:to => @recipients, :subject => @subject)
  end

  def reset_password(user)
    setup_email(user)
    headers     "category" => "Reset password"
    headers     'X-SMTPAPI' => '{"category" : "Reset password"}'

    @subject    += "#{:user_information.l(:site => configatron.community_name)}"
    mail(:to => @recipients, :subject => @subject)
  end

  def forgot_username(user)
    setup_email(user)
    headers     "category" => "Forgot password"
    headers     'X-SMTPAPI' => '{"category" : "Forgot password"}'

    @subject    += "#{:user_information.l(:site => configatron.community_name)}"
    mail(:to => @recipients, :subject => @subject)
  end

  helper_method :inspect_object

  def inspect_object(object)
    case object
    when Hash, Array
      object.inspect
    when ActionController::Base
      "#{object.controller_name}##{object.action_name}"
    else
      object.to_s
    end
  end


  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    setup_sender_info
    @subject     = "[#{configatron.community_name}] "
    @sent_on     = Time.now
    @user = @body[:user]  = user
  end

  def setup_sender_info
    @from       = "Infrno <support@infrno.net>"
    headers     "Reply-to" => "#{configatron.support_email}"
    #@content_type = "text/plain"
  end


end
