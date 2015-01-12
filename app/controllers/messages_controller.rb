class MessagesController < BaseController

  before_filter :find_user, :except => [:auto_complete_for_username]
  before_filter :login_required
  before_filter :require_ownership_or_moderator, :except => [:auto_complete_for_username]

  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_username]

  def auto_complete_for_username
    @users = User.all(:conditions => [ 'LOWER(login) LIKE ?', '%' + (params[:message][:to]) + '%' ])
    render :inline => "<%= infrno_auto_complete_result(@users, 'login') %>"
  end

  def index
    if params[:mailbox] == "sent"
      @messages = @user.sent_messages.page(params[:page]).per(100)
    else
      @messages = @user.message_threads_as_recipient.order('updated_at DESC').page(params[:page]).per(100)
    end
  end

  def show
    begin
      @message = Message.read(params[:id], current_user)
      @message_thread = MessageThread.for(@message, (admin? ? @message.recipient : current_user ))
    rescue
      flash[:error] = "You may not view messages that are not yours."
      redirect_to home_url
    end
  end

  def new
    @recipient_names = ''

    if params[:reply_to]
      @in_reply_to = Message.find_by_id(params[:reply_to])
      @message_thread = MessageThread.for(@in_reply_to, current_user)
      
      if @in_reply_to.sender.id == current_user.id
        @recipient_names = @in_reply_to.recipient.display_name
        @to = @in_reply_to.recipient.login_slug
      else
        @recipient_names = @in_reply_to.sender.display_name
        @to = @in_reply_to.sender.login_slug
      end
    else
      params[:to].split(',').uniq.each do |to|
        if !@recipient_names.blank?
          @recipient_names << ", "
        end
        u =  User.find_by_login_slug(to.strip)
        if u
          @recipient_names << u.display_name
        end
      end
    end

    @message = Message.new_reply(@user, @message_thread, params)
    @message.subject = params[:subject] || @message.subject
    logger.info "message_controller.new() message=" +@message.inspect
  end

  def create
    messages = []

    if params[:message][:to].blank?
      # If 'to' field is empty, call validations to catch other errors
      @message = Message.new(params[:message])
      @message.valid?
      render :action => :new and return
    else
      params[:message][:to].split(',').uniq.each do |to|
        this_message = {:to => to, :parent_id =>  params[:message][:parent_id], :subject =>  params[:message][:subject], :body =>  params[:message][:body]}
        @message = Message.new(this_message)

        # Kieara's messages go to Mike
        recipient = User.find_by_login_slug(to.strip)
        if recipient.id == 5
          recipient = User.find(1)
        end
        @message.recipient = recipient

        @message.sender = @user
        unless @message.valid?
          render :action => :new and return
        else
          @message.save!
        end
      end
      flash[:notice] = :message_sent.l
      redirect_to user_messages_path(@user) and return
    end
  end

  def delete_selected
    if request.post?
      if params[:delete]
        params[:delete].each { |id|
          @message = Message.find(:first, :conditions => ["messages.id = ? AND (sender_id = ? OR recipient_id = ?)", id, @user, @user])
          @message.mark_deleted(@user) unless @message.nil?
        }
        flash[:notice] = :messages_deleted.l
      end
      redirect_to user_messages_path(@user)
    end
  end

  def delete_message_threads
    if request.post?
      if params[:delete]
        params[:delete].each { |id|
          message_thread = MessageThread.find_by_id_and_recipient_id(id, @user.id)
          message_thread.destroy if message_thread
        }
        flash[:notice] = :messages_deleted.l
      end
      redirect_to user_messages_path(@user)
    end

  end


  
#  def destroy
#    @message = Message.find(:first, :conditions => ["messages.id = ? AND (sender_id = ? OR recipient_id = ?)", params[:id], current_user.id, current_user.id])
#    if @message
#      @message.mark_deleted(@user)
#      flash[:notice] = 'Message deleted.'
#    else
#      flash[:notice] = 'You are not allowed to delete messages you do not own.'
#    end
#
#    redirect_to user_messages_path(@user)
#  end

  def new_newsletter
    @message = Message.new()
    @message.subject = "Infrno Newsletter"
  end

  def send_newsletter
    messages = []

    if current_user && current_user.admin?
      UserNotifier.deliver_newsletter(params[:subject], params[:message])
    end

    redirect_to user_messages_path(@user)
  end


  private
    def find_user
      @user = User.find(params[:user_id])
    end

    def require_ownership_or_moderator
      unless admin? || moderator? || (@user && (@user.eql?(current_user)))
        redirect_to :controller => 'sessions', :action => 'new' and return false
      end
      return @user
    end
end
