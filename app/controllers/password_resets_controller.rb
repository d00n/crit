class PasswordResetsController < BaseController
  require_from_ce('controllers/password_resets_controller')

  def new
    render :layout => 'single_column'
  end

  def create
    @user = User.where("lower(email) = ?", params[:email].downcase).first
    if @user
      @user.deliver_password_reset_instructions!

      flash[:info] = :your_password_reset_instructions_have_been_emailed_to_you.l      

      redirect_to login_path
    else
      flash[:error] = :sorry_we_dont_recognize_that_email_address.l

      render :layout => 'single_column', :action => :new
    end
  end

  def edit
    render :layout => 'single_column'
  end

  def update
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]

    # If the user is clicking on a 'reset password' link we emailed him, he's confirming that email
    if !@user.active?
      @user.activate
      @user.last_request_at = Time.now
      @user.save
    end


    if @user.save
      flash[:notice] = :your_changes_were_saved.l

      redirect_to home_path(@user)
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :action => :edit
    end
  end


  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = 'That link has expired.'
      redirect_to login_path
    end
  end

end