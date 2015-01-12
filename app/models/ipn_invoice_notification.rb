class IpnInvoiceNotification < ActiveRecord::Base
  belongs_to :user
  serialize :params

  def process_notification(request)
    logger.info("IpnInvoiceNotification.process_notification: #{params}")

    if (params[:custom].nil?)
      logger.error("IPN invoice error: user_id missing")
      UserNotifier.access_violation_notice('IPN invoice error: user_id missing', request).deliver
      raise IpnError
      return
    end

    begin
      user = User.find(params[:custom])
      self.user = user
      self.save!
    rescue
      logger.error("IPN invoice error: user lookup failed")
      UserNotifier.access_violation_notice('IPN invoice error: user lookup failed', request).deliver
      raise IpnError
      return
    end

    if params[:receiver_email] != PAYPAL_EMAIL
      logger.error("IPN invoice error: receiver_email does not match")
      UserNotifier.access_violation_notice('IPN invoice error: receiver_email does not match', request).deliver
      raise IpnError
      return
    end

    if params[:mc_currency] != "USD"
      logger.error("IPN invoice error: currency does not match")
      UserNotifier.access_violation_notice('IPN invoice error: currency does not match', request).deliver
      raise IpnError
      return
    end


    if params[:payment_status] == "Completed"
      user.membership_level = 3
      user.save!
      begin
        facebook_auth = user.authorizations.find_by_provider('facebook')

        if !facebook_auth.nil?
          fb_user = FbGraph::User.me(facebook_auth.access_token)

          if !fb_user.nil?  && user.last_fb_autopost < Time.now.utc - 1.day

            message = "#{user.first_name} upgraded to the Exalted membership level on Infrno.net!"

            caption = "Nobody loves role players like Infrno does, and it's FREE! Come roll some dice with us!"

            description = "#{configatron.meta_description}"


            fb_user.feed!(
                :message => "#{message}",
                :picture => APP_URL + User.find(5).avatar_photo_url(:thumb),
                :link => 'http://www.infrno.net',
                :name => 'http://www.infrno.net',
                :caption => "#{caption}",
                :description => "#{description}"
            )

            user.last_fb_autopost = Time.now.utc
            user.save

            logger.info "Facebook premium membership wall post success: #{user.login_slug}"
          end
        end
      rescue
        logger.error "Could not deliver premium membership feed story to Facebook. Error: #{$!}"
        return
      end
    end
  end

end
