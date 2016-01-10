class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery

  def raise_not_found
    respond_to do |format|
      format.all {
        render :nothing => true, status: 404
      }
    end
  end

  rescue_from ActionController::UnknownController, with: -> { raise_not_found  }
  rescue_from ActiveRecord::RecordNotFound, with: -> { raise_not_found  }
end
