class AuthorizationsController < BaseController
  require_from_ce('controllers/authorizations_controller')

  #before_filter :login_required, :only => [:destroy]

  #def create
  #  omniauth = request.env['omniauth.auth'] #this is where you get all the data from your provider through omniauth
  #  provider_name = omniauth['provider'].capitalize
  #
  #  logger.info 'omniauth: ' + omniauth.inspect
  #
  #  @auth = Authorization.find_or_create_from_hash(omniauth, current_user)
  #
  #  if logged_in?
  #    #flash[:notice] = t('authorizations.create.success_existing_user', :provider => provider_name)
  #  elsif @auth.valid?
  #    #flash[:notice] = t('authorizations.create.success_message', :provider => provider_name)
  #    @user_session = UserSession.create(@auth.user, true)
  #
  #    #if current_user has been called before this, it will ne nil, so we have to make to reset it
  #    current_user = @user_session.record
  #  end
  #
  #  logger.info "old access token: #{@auth.access_token}"
  #  if @auth.access_token != omniauth["credentials"]["token"]
  #    logger.info "new access token: #{omniauth["credentials"]["token"]}"
  #    @auth.user.update_attributes(:token => omniauth["credentials"]["token"])
  #  end
  #
  #  if @auth.user
  #    create_friendship_with_kieara(@auth.user)
  #    post_to_facebook_user_joined_infrno(@auth.user)
  #  end
  #
  #  if current_user
  #    #redirect_to request.env['omniauth.origin'] || home_url #|| user_path(@auth.user)
  #    if @auth.user.membership_level > 0
  #      redirect_to home_url
  #    else
  #      redirect_to premium_membership_path
  #    end
  #  elsif @auth
  #    flash[:error] = "Auth errors: " + @auth.errors.full_messages.to_sentence
  #    redirect_to login_path
  #  elsif @auth.user
  #    flash[:error] = "Auth.user errors: " + @auth.user.errors.full_messages.to_sentence
  #    redirect_to login_path
  #  else
  #    flash[:error] = "current_user and auth are nil"
  #    redirect_to login_path
  #  end
  #end
  #
  #def failure
  #  flash[:notice] = t('authorizations.failure.notice')
  #  redirect_to home_url
  #end
  #
  #def destroy
  #  logger.info "authorizations_controller.destroy"
  #  @authorization = current_user.authorizations.find(params[:id])
  #
  #  if @authorization.destroy
  #    flash[:notice] = t('authorizations.destroy.notice', :provider => @authorization.provider.capitalize)
  #  else
  #    flash[:notice] = @authorization.errors.full_messages.to_sentence
  #  end
  #
  #  redirect_to edit_account_user_path
  #end
end
