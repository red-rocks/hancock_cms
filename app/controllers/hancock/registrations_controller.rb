class Hancock::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_recaptcha, only: [:create]

  private
  def check_recaptcha
    if Hancock.config.recaptcha_support and (!Rails.env.development? or Hancock.config.captcha_on_development)
      if verify_recaptcha
        true
      else
        self.resource = resource_class.new sign_up_params
        self.resource.valid?
        @recaptcha_error = "Вы робот?".freeze
        respond_with_navigational(resource) { render :new }
      end

    else
      true
    end
  end

end
