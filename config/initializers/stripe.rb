if Rails.env.development?
  Rails.configuration.stripe = {
      :publishable_key => 'pk_test_51N120YLfu0OvhwDhZkd0yuqgpnkDM9nZ36f2Fa8HVmj9qEx5PhUnNet0oGRBEzlwfRFzIOuKmLEo8adEJN7WsLMt004xq2otnz',
      :secret_key      => 'sk_test_51N120YLfu0OvhwDh4Vx745mv6vxVrMJSOw63yVXJwvob0lHF8Ixyv3V1KMR21tCsjcqwR72gjbHlkbsUctd4fdoc00ajBXkVq3'
    }
  end
  
  if Rails.env.production?
    Rails.configuration.stripe = {
    :publishable_key => 'pk_test_51N120YLfu0OvhwDhZkd0yuqgpnkDM9nZ36f2Fa8HVmj9qEx5PhUnNet0oGRBEzlwfRFzIOuKmLEo8adEJN7WsLMt004xq2otnz',
    :secret_key      => 'sk_test_51N120YLfu0OvhwDh4Vx745mv6vxVrMJSOw63yVXJwvob0lHF8Ixyv3V1KMR21tCsjcqwR72gjbHlkbsUctd4fdoc00ajBXkVq3'
}

end

if Rails.env.test?
  Rails.configuration.stripe = {
    :publishable_key => 'pk_test_51N120YLfu0OvhwDhZkd0yuqgpnkDM9nZ36f2Fa8HVmj9qEx5PhUnNet0oGRBEzlwfRFzIOuKmLEo8adEJN7WsLMt004xq2otnz',
    :secret_key      => 'sk_test_51N120YLfu0OvhwDh4Vx745mv6vxVrMJSOw63yVXJwvob0lHF8Ixyv3V1KMR21tCsjcqwR72gjbHlkbsUctd4fdoc00ajBXkVq3'
  }
end

Stripe.api_key = Rails.configuration.stripe[:secret_key]
