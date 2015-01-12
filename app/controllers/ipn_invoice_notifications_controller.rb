class IpnInvoiceNotificationsController < ApplicationController
  include ActiveMerchant::Billing::Integrations
  protect_from_forgery :except => [:create]
  skip_before_filter :set_timezone
  skip_before_filter :set_locale
  
  def create
    logger.info("IpnInvoiceNotificationsController.create() #{request.raw_post}")

    notify = Paypal::Notification.new(request.raw_post)

    if notify.nil?
      logger.error("IpnInvoiceNotificationsController error: notify is nil")
      UserNotifier.access_violation_notice("IpnInvoiceNotificationsController error: notify is nil", request).deliver
      render :nothing => true, :status => :bad_request
      return
    end

    if notify.acknowledge

      logger.info("IpnInvoiceNotificationsController: about to create IpnInvoiceNotification")
      begin
        # This needs validations in the model
        iin = IpnInvoiceNotification.create!(
            :params => params,
            :payment_status => params[:payment_status],
            :ipn_track_id => params[:ipn_track_id],
            :item_name => params[:item_name],
            :txn_type => params[:txn_type],
            :payment_gross => params[:payment_gross],
            :payer_email => params[:payer_email],
            :first_name => params[:first_name],
            :last_name => params[:last_name] )

        iin.process_notification(request)

      rescue => e
        logger.error("IpnInvoiceNotificationsController error: creation or processing failed: #{e}")
        UserNotifier.access_violation_notice("IpnInvoiceNotificationsController error: creation or processing failed, #{e}", request).deliver
        render :nothing => true
        return
      end

    else
      logger.error("IpnInvoiceNotificationsController error: notify.acknowledge returned false")
      UserNotifier.access_violation_notice('IpnInvoiceNotificationsController error: notify.acknowledge returned false', request).deliver
      render :nothing => true, :status => :bad_request
      return
    end

    render :nothing => true
  end
end
