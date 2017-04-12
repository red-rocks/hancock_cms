class Hancock::SessionsController < Devise::SessionsController
  prepend_before_action :check_recaptcha, only: [:create]
  prepend_before_action :require_no_authentication, :only => [ :new, :create ]

  # private :check_recaptcha
  def check_recaptcha
    if Hancock.config.recaptcha_support and (!Rails.env.development? or Hancock.config.captcha_on_development)
      unless verify_recaptcha
        self.resource = resource_class.new sign_in_params
        resource.errors.add(:email, "Неверный e-mail или пароль".freeze)
        resource.errors.add(:password, "Неверный e-mail или пароль".freeze)
        @recaptcha_error = "Вы робот?".freeze
        respond_with_navigational(resource) { render :new }
      end
    end
  end
  
  include Hancock::Decorators::Sessions

end
