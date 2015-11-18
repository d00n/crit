class SessionsController < BaseController
  require_from_ce('controllers/sessions_controller')

  def create

    l = params[:login]
    pw = params[:password]
    rm = params[:remember_me]

    @user_session = UserSession.new(:login => l, :password => pw, :remember_me => rm)

    if @user_session.save
      self.current_user = @user_session.record #if current_user has been called before this, it will ne nil, so we have to make to reset it

      #flash[:notice] = :thanks_youre_now_logged_in.l
      redirect_back_or_default(home_path)
    else
      flash[:notice] = :uh_oh_we_couldnt_log_you_in_with_the_username_and_password_you_entered_try_again.l
      render :action => :new, :email => params[:email]
    end
  end


  skip_before_filter :verify_authenticity_token, :only => :create
  #
  #def new
  #  redirect_to home_url and return if current_user
  #  @user_session = UserSession.new
  #  @target_page = params[:target_page]
  #  render :layout => 'single_column'
  #end
  #
  #def create
  #  logger.info "sessions_controller.create XX"
  #
  #  user = User.where("login=?", params[:login]).first
  #  if user && user.is_banned
  #    logger.info "sessions_controller.create banned"
  #    flash[:error] = 'You have been banned.'
  #    redirect_to(home_path)
  #    return
  #  end
  #
  #  @user_session = UserSession.new(:login => params[:login], :password => params[:password], :remember_me => params[:remember_me])
  #
  #  target_page = params[:target_page]
  #  if @user_session.save
  #
  #    #if current_user has been called before this, it will be nil, so we have to call 'record' to reset it
  #    current_user = @user_session.record
  #
  #    flash.clear
  #    if target_page == 'link_accounts'
  #      redirect_to(new_facebook_path)
  #    elsif target_page == 'premium_membership'
  #      redirect_to(premium_membership_path)
  #    else
  #      # not sure why current_user is nil these days, but hack hack hack
  #      #redirect_to(dashboard_user_path(current_user))
  #      redirect_to(home_url)
  #    end
  #  else
  #    if !@user_session.errors.blank?
  #      flash[:error] = @user_session.errors.messages[:base]
  #    else
  #      flash[:error] = :uh_oh_we_couldnt_log_you_in_with_the_username_and_password_you_entered_try_again.l
  #    end
  #
  #    redirect_to :action => :new
  #  end
  #end

  #def destroy
  #  logger.info "sessions_controller.destroy"
  #
  #  cookies.delete :auth_token
  #
  #  # Failed FB Connect logins wind up here, and current_user_session is nil
  #  if !current_user_session.nil?
  #    current_user_session.destroy
  #    flash[:notice] = :youve_been_logged_out_hope_you_come_back_soon.l
  #  end
  #
  #  reset_session
  #
  #  Time.zone = 'Tijuana'
  #
  #  #redirect_to new_session_path
  #  redirect_to :controller => 'base', :action => 'welcome'
  #end

end
