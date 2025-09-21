# frozen_string_literal: true

require 'net/http'
require 'json'

class BrevoDeliveryMethod
  def initialize(settings)
    @settings = settings
  end

  def deliver!(mail)
    api_key = Rails.application.credentials.dig(:brevo, :api_key)

    uri = URI('https://api.brevo.com/v3/smtp/email')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['accept'] = 'application/json'
    request['api-key'] = api_key
    request['content-type'] = 'application/json'

    body = {
      sender: { email: mail.from.first },
      to: mail.to.map { |email| { email: email } },
      subject: mail.subject,
      htmlContent: mail.html_part&.body&.to_s,
      textContent: mail.text_part&.body&.to_s || mail.body.to_s
    }

    request.body = body.to_json
    response = http.request(request)

    unless response.code.to_i.between?(200, 299)
      raise "Brevo API error: #{response.code} - #{response.body}"
    end
  end
end

ActionMailer::Base.add_delivery_method :brevo, BrevoDeliveryMethod
