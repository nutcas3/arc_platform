# frozen_string_literal: true

class BrevoDeliveryMethod
  def initialize(settings)
    @settings = settings
  end

  def deliver!(mail)
    client = Brevo::Client.new(Rails.application.credentials.dig(:brevo, :api_key))

    client.send_transactional_email(
      sender: { email: mail.from.first },
      to: mail.to.map { |email| { email: email } },
      subject: mail.subject,
      html_content: mail.html_part&.body&.to_s,
      text_content: mail.text_part&.body&.to_s || mail.body.to_s
    )
  end
end

ActionMailer::Base.add_delivery_method :brevo, BrevoDeliveryMethod
