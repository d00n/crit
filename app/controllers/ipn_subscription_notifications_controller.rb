class IpnSubscriptionNotificationsController < ApplicationController
  include ActiveMerchant::Billing::Integrations
  protect_from_forgery :except => [:create]
  skip_before_filter :set_timezone
  skip_before_filter :set_locale

  def create
    logger.info("IpnSubscriptionNotificationsController.create() #{request.raw_post}")

    notify = Paypal::Notification.new(request.raw_post)

    if notify.nil?
      logger.error("IpnSubscriptionNotificationsController error: notify is nil")
      UserNotifier.access_violation_notice("IpnSubscriptionNotificationsController error: notify is nil", request).deliver
      render :nothing => true, :status => :bad_request
      return
    end

    if notify.acknowledge

      logger.info("IpnSubscriptionNotificationsController: about to create IpnSubscriptionNotification")
      begin
        # This needs validations in the model
        isn = IpnSubscriptionNotification.create!(
            :params => params,
            :txn_type => params[:txn_type],
            :subscr_id => params[:subscr_id],
            :ipn_track_id => params[:ipn_track_id],
            :payment_gross => params[:payment_gross],
            :payer_email => params[:payer_email],
            :first_name => params[:first_name],
            :last_name => params[:last_name] )

        isn.process_notification(request)

      rescue => e
        logger.error("IpnSubscriptionNotificationsController error: creation or processing failed: #{e}")
        UserNotifier.access_violation_notice("IpnSubscriptionNotificationsController error: creation or processing failed, #{e}", request).deliver
        render :nothing => true
        return
      end
      

    else
      logger.error("IpnSubscriptionNotificationsController error: notify.acknowledge returned false")
      UserNotifier.access_violation_notice('IpnSubscriptionNotificationsController error: notify.acknowledge returned false', request).deliver
      render :nothing => true, :status => :bad_request
      return
    end

    render :nothing => true
  end
end
