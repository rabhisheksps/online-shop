class ApplicationController < ActionController::Base

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  add_flash_types :info, :error, :warning, :notice

  config.after_initialize do
    Stripe.api_key = Rails.application.credentials[:stripe_secret_key]
  end
  
  protected

  def configure_permitted_parameters
    attributes = [:first_name, :last_name, :email, :phone_number, :dob, :role, :profile_picture]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end
end
