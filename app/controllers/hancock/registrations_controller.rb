class Hancock::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_recaptcha, only: [:create]

  # private :check_recaptcha
  def check_recaptcha
    if Hancock.config.recaptcha_support and (!Rails.env.development? or Hancock.config.captcha_on_development)
      unless verify_recaptcha
        self.resource = resource_class.new sign_up_params
        self.resource.valid?
        @recaptcha_error = "Вы робот?".freeze
        respond_with_navigational(resource) { render :new }
      end
    end
  end

  include Hancock::Decorators::Registrations

end
