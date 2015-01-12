class ContactController < BaseController
  def index
    render :layout => 'single_column'
  end

  def create
    if UserNotifier.contact(params, request.env['HTTP_USER_AGENT']).deliver
      flash[:notice] = "Email was successfully sent."
      redirect_to('/')
    else
      flash.now[:error] = "An error occurred while sending this email."
      render :index
    end
  end

end
