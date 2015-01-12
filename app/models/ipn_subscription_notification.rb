class IpnSubscriptionNotification < ActiveRecord::Base
  belongs_to :user
  serialize :params

  class IpnError < StandardError
  end

  # @param request [Object]
  def process_notification(request)
    logger.info("IpnSubscriptionNotification.process_notification: #{params}")

    if params[:custom]
      begin
        user = User.find(params[:custom])
        self.user = user
        self.save!
      rescue
        logger.error("IPN subscription error: user lookup failed")
        UserNotifier.access_violation_notice('IPN subscription error: user lookup failed', request).deliver
        raise IpnError
        return
      end
    else
      #user = User.find_by_email( params[:payer_email] )
      #user.email = params[:payer_email]
      #user.first_name = params[:first_name]
      #user.last_name = params[:last_name]
    end

    if params[:receiver_email] != PAYPAL_EMAIL
      logger.error("IPN subscription error: receiver_email does not match")
      UserNotifier.access_violation_notice('IPN subscription error: receiver_email does not match', request).deliver
      raise IpnError
      return
    end

    if params[:mc_currency] != "USD"
      logger.error("IPN subscription error: currency does not match")
      UserNotifier.access_violation_notice('IPN subscription error: currency does not match', request).deliver
      raise IpnError
      return
    end


    if (params[:txn_type] == 'subscr_signup')
      # Just a header record, no payment involved

    elsif (params[:txn_type] == 'subscr_cancel')
      self.user.membership_level = 0
      self.user.save!

    elsif (params[:txn_type] == 'subscr_modify')
      # usually(?) for address changes, which we don't care about

    elsif (params[:txn_type] == 'subscr_failed')
      # Paypal tries 3 times, and then cancels the subscription

    elsif (params[:txn_type] == 'subscr_payment')


      if params[:payment_gross] == configatron.EPIC_MONTHLY_AMOUNT ||
          params[:payment_gross] == configatron.EPIC_SEMIANNUAL_AMOUNT ||
          params[:payment_gross] == configatron.EPIC_ANNUAL_AMOUNT
        self.user.membership_level = 1
        self.user.save!
        level_name = "Epic"
      elsif params[:payment_gross] == configatron.LEGENDARY_MONTHLY_AMOUNT ||
          params[:payment_gross] == configatron.LEGENDARY_SEMIANNUAL_AMOUNT ||
          params[:payment_gross] == configatron.LEGENDARY_ANNUAL_AMOUNT
        self.user.membership_level = 2
        self.user.save!
        level_name = "Legendary"
      elsif params[:payment_gross] == configatron.EXALTED_MONTHLY_AMOUNT ||
         params[:payment_gross] == configatron.EXALTED_SEMIANNUAL_AMOUNT ||
         params[:payment_gross] == configatron.EXALTED_ANNUAL_AMOUNT
        self.user.membership_level = 3
        self.user.save!
        level_name = "Exalted"
      else
        msg = "process_notification: unknown subscription amount, user.id=#{user.id}, ipn_track_id=#{params[:ipn_track_id]}"
        logger.error(msg)
        UserNotifier.access_violation_notice(msg, request).deliver
        return
      end

      if !self.user.posted_to_facebook_account_upgrade
        begin
          facebook_auth = self.user.authorizations.find_by_provider('facebook')

          if !facebook_auth.nil?
            fb_user = FbGraph::User.me(facebook_auth.access_token)

            if !fb_user.nil?  # && user.last_fb_autopost < Time.now.utc - 1.day

              message = "#{self.user.first_name} is #{level_name} on Infrno.net!"

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

              self.user.posted_to_facebook_account_upgrade = true
              self.user.last_fb_autopost = Time.now.utc
              self.user.save

              logger.info "Facebook premium membership wall post success: #{user_url user}"
            end
          end
        rescue
          logger.error "Could not deliver premium membership feed story to Facebook. Error: #{$!}"
          return
        end
      end

      # thank you email...

    elsif (params[:txn_type] == 'subscr_eot')
      # not possible, as we don't specify a term

    end

  end
end
