class IntakeSurveyController < BaseController
  before_filter :login_required
  include ActionView::Helpers::SanitizeHelper
  extend  ActionView::Helpers::SanitizeHelper::ClassMethods # Required for rails 2.2
  
  def index
    respond_to do |format|
      format.html
      format.xml
    end
  end

  def create
    @user = current_user
    @intake_survey = IntakeSurvey.new
    @intake_survey.login = current_user.login
    @intake_survey.q1 = params[:intake_survey][:q1]
    @intake_survey.q2 = params[:intake_survey][:q2]
    @intake_survey.q3 = params[:intake_survey][:q3]
    @intake_survey.q4 = params[:intake_survey][:q4]
    @intake_survey.q5 = params[:intake_survey][:q5]
    @intake_survey.q6 = params[:intake_survey][:q6]
    @intake_survey.q7 = params[:intake_survey][:q7]
    @intake_survey.q8 = params[:intake_survey][:q8]
    @intake_survey.q9 = params[:intake_survey][:q9]

    respond_to do |format|
      if @intake_survey.save
        flash[:notice] = "Thanks for taking our survey!"
        format.html {redirect_to user_path(@user)}
        format.xml
      else
        format.html {render :action => "index"}
        format.xml
      end
    end
  end

end
