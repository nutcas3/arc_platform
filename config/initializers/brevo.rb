# frozen_string_literal: true

require 'net/http'
require 'json'

class BrevoDeliveryMethod
  def initialize(settings)
    @settings = settings
  end

  def deliver!(mail)
    validate_mail!(mail)
    
    api_key = Rails.application.credentials.dig(:brevo, :api_key)
    uri = URI('https://api.brevo.com/v3/smtp/email')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['accept'] = 'application/json'
    request['api-key'] = api_key
    request['content-type'] = 'application/json'

    body = {
      sender: { 
        email: @settings[:default_sender_email] || mail.from.first,
        name: @settings[:sender_name] || 'Africa Ruby Community'
      },
      to: mail.to.map { |email| { email: email } },
      subject: mail.subject,
      htmlContent: mail.html_part&.body&.to_s,
      textContent: mail.text_part&.body&.to_s || mail.body.to_s
    }

    request.body = body.to_json
    response = http.request(request)

    unless response.code.to_i.between?(200, 299)
      Rails.logger.error "Brevo API Error: #{response.code} - #{response.body}"
      raise "Email delivery failed: #{response.code} - #{response.body}"
    end
  end

  private

  def validate_mail!(mail)
    raise ArgumentError, 'Mail object cannot be nil' if mail.nil?
    raise ArgumentError, 'Mail must have from address' if mail.from.nil? || mail.from.empty?
    raise ArgumentError, 'Mail must have to address' if mail.to.nil? || mail.to.empty?
    raise ArgumentError, 'Mail must have subject' if mail.subject.nil? || mail.subject.empty?
  end
end

ActionMailer::Base.add_delivery_method :brevo, BrevoDeliveryMethod, {
  default_sender_email: 'noreply@rubycommunity.africa',
  sender_name: 'Africa Ruby Community'
}