class Hancock::SessionsController < Devise::SessionsController
  prepend_before_action :check_recaptcha, only: [:create]

  private
  def check_recaptcha
    if Hancock.config.recaptcha_support
      if verify_recaptcha
        true
      else
        self.resource = resource_class.new sign_in_params
        resource.errors.add(:email, "Неверный e-mail или пароль".freeze)
        resource.errors.add(:password, "Неверный e-mail или пароль".freeze)
        @recaptcha_error = "Вы робот?".freeze
        respond_with_navigational(resource) { render :new }
      end

    else
      true
    end
  end

end
