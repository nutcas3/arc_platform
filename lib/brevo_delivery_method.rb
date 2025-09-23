# frozen_string_literal: true

require 'brevo'

class BrevoDeliveryMethod
  def initialize(settings)
    @settings = settings
  end

  def deliver!(mail)
    api_instance = Brevo::TransactionalEmailsApi.new
    
    send_smtp_email = Brevo::SendSmtpEmail.new(
      sender: { email: mail.from.first },
      to: mail.to.map { |email| { email: email } },
      subject: mail.subject,
      html_content: mail.html_part&.body&.to_s,
      text_content: mail.text_part&.body&.to_s || mail.body.to_s
    )

    api_instance.send_transac_email(send_smtp_email)
  end
end