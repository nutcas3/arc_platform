# frozen_string_literal: true

require 'brevo'
require 'brevo_delivery_method'

Brevo.configure do |config|
  config.api_key['api-key'] = Rails.application.credentials.dig(:brevo, :api_key)
end

# Register Brevo as a valid ActionMailer delivery method with default settings
ActionMailer::Base.add_delivery_method :brevo, BrevoDeliveryMethod, {
  default_sender_email: 'noreply@rubycommunity.africa',
  sender_name: 'Africa Ruby Community'
}