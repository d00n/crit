include ActionView::Helpers::SanitizeHelper

class AddressesController < BaseController

  before_filter :login_required

  def show
    @user = User.find(params[:id])

    @user.address ||= Address.new
    @address = @user.address

    respond_to do |format|
      format.html { render :layout => 'application' }
    end
  end

  def update
    @user = User.find(params[:id])
    @address = @user.address
    @address.attributes=params[:address]

    @address.line_one = params[:address][:line_one]
    @user.save!

    respond_to do |format|
      if @address.save
        flash[:notice] = 'Address was successfully updated.'
        format.html { redirect_to(@user) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

end
