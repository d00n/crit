class Message < ActiveRecord::Base
  require_from_ce('models/message')

#  def self.new_reply(sender, in_reply_to = nil, params = {})
#    message = new(params[:message])
#    message.to ||= params[:to] if params[:to]
#    message.subject = params[:subject] if params[:subject]
#
#    if in_reply_to
#      return nil if in_reply_to.recipient != sender #can only reply to messages you received
#      message.reply_to = in_reply_to
#      message.to = in_reply_to.sender.login
#      message.body = "\n\n*Original message*\n\n #{in_reply_to.body}"
#      message.sender = sender
#      if in_reply_to.subject.starts_with? 'Re:'
#        message.subject = in_reply_to.subject
#      else
#        message.subject = "Re: #{in_reply_to.subject}"
#      end
#    end
#
#    message
#  end

  def ensure_not_sending_to_self
    # yeah, I don't care
    #errors.add_to_base("You may not send a message to yourself.") if self.recipient && self.recipient.eql?(self.sender)
  end
  
end