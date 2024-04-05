class Users::RegistrationsController < Devise::RegistrationsController
  # def update_resource(resource, params)
  #   if resource.provider == 'google_oauth2'
  #     params.delete('current_password')
  #     resource.password = params['password']
  #     resource.update_without_password(params)
  #   else
  #     resource.update_with_password(params)
  #   end
  # end

  def create
    if verify_recaptcha
      super
    else
      build_resource(sign_up_params)
      clean_up_passwords(resource)
      resource.errors.add(:recaptcha_error, "There was an error with the recaptcha below. Please verify recaptcha.")
      respond_with_navigational(resource) { render :new }
    end
  end

end
