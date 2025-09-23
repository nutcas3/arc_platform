# frozen_string_literal: true

require 'brevo'
require Rails.root.join('lib', 'brevo_delivery_method')

Brevo.configure do |config|
  config.api_key['api-key'] = Rails.application.credentials.dig(:brevo, :api_key)
end

ActionMailer::Base.add_delivery_method :brevo, BrevoDeliveryMethod