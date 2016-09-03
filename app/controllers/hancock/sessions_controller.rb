class Hancock::SessionsController < Devise::SessionsController
  prepend_before_action :check_recaptcha, only: [:create]

  private
  def check_recaptcha
    if Hancock.config.recaptcha_support
      if verify_recaptcha
        true
      else
        self.resource = resource_class.new sign_in_params
        resource.errors.add(:email, "Неверный e-mail или пароль")
        resource.errors.add(:password, "Неверный e-mail или пароль")
        @recaptcha_error = "Вы робот?"
        respond_with_navigational(resource) { render :new }
      end

    else
      true
    end
  end

end
