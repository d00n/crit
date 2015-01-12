module PaypalHelper
  def premium_label(membership_level = 0)
    case membership_level
      when 0
        return '/assets/membership/infrnal.png'
      when 1
        return '/assets/membership/epic.png'
      when 2
        return '/assets/membership/legendary.png'
      when 3
        return '/assets/membership/exalted.png'
      when 4
        return '/assets/membership/mythic.png'
    end
  end


  def premium_glyph(membership_level = 0)
    if membership_level == 1
      return '/assets/E_16x16.png'
    elsif membership_level == 2
      return '/assets/L_16x16.png'
    elsif membership_level == 3
      return '/assets/X_16x16.png'
    elsif membership_level == 4
      return '/assets/M_16x16.png'
    end
  end

  def paypal_encrypted_subscription(item_name, amount_per_period, months_per_period)

    # Page 435:
    # https://cms.paypal.com/cms_content/US/en_US/files/developer/PP_WebsitePaymentsStandard_IntegrationGuide.pdf
    values = {
        "business" => "#{PAYPAL_EMAIL}",
        "item_name" => "#{item_name}",
        "a3" => "#{amount_per_period}",
        "t3" => "M",
        "p3" => "#{months_per_period}",
        "src" => "1",
        "cert_id" => "#{PAYPAL_CERT_ID}",
        "cmd" => "_xclick-subscriptions",
        "currency_code" => "USD",
        "no_note" => "1",
        "no_shipping" => "1",
        "return" => "#{membership_thank_you_url}",
        "notify_url" => "#{ipn_subscription_notifications_url}"}

    if !current_user.nil?
        values["custom"] = "#{current_user.id}"
        values["email"] = current_user.email
        values["first_name"] = current_user.first_name
        values["last_name"] = current_user.last_name
        values["state"] = current_user.state
        values["zip"] = current_user.zip
    end

    logger.debug values

    encrypt_for_paypal(values)
  end

  def paypal_encrypted_invoice(item_name, total_amount)

    # cert_id is the certificate if we see in paypal when we upload our own certificates
    # cmd _xclick need for buttons
    # item name is what the user will see at the paypal page
    # custom and invoice are passthrough vars which we will get back with the asunchronous
    # notification
    # no_note and no_shipping means the client want see these extra fields on the paypal payment
    # page
    # return is the url the user will be redirected to by paypal when the transaction is completed.
    values = {
        "business" => PAYPAL_EMAIL,
        "item_name" => item_name,
        "cert_id" => PAYPAL_CERT_ID,
        "cmd" => "_xclick",
        "item_number" => "1",
        "amount" => total_amount,
        "currency_code" => "USD",
        "country" => "US",
        "no_note" => "1",
        "no_shipping" => "1",
        "return" => membership_thank_you_url,
        "notify_url" => ipn_invoice_notifications_url}


    if !current_user.nil?
      values["custom"] = "#{current_user.id}"
      values["email"] = current_user.email
      values["first_name"] = current_user.first_name
      values["last_name"] = current_user.last_name
      values["state"] = current_user.state
      values["zip"] = current_user.zip
    end


    logger.debug values

    encrypt_for_paypal(values)
  end

  def encrypt_for_paypal(values)
    paypal_cert_pem = File.read(Rails.root.to_s + PAYPAL_CERT)
    app_cert_pem = File.read(Rails.root.to_s + INFRNO_CERT)
    app_key_pem = File.read(Rails.root.to_s + INFRNO_KEY)

    signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(app_cert_pem), OpenSSL::PKey::RSA.new(app_key_pem, ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)
    OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(paypal_cert_pem)], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
  end

end