class Hancock::SessionsController < Devise::SessionsController
  prepend_before_action :check_recaptcha, only: [:create]
  prepend_before_action :require_no_authentication, :only => [ :new, :create ]


  def new
    self.resource = resource_class.new(sign_in_params)
    if request.env["warden.options"] and request.env["warden.options"][:recall] == "hancock/sessions#new"
      set_login_password_errors
    end
    @enter_site_error = flash["enter_site_error"]
    flash.delete(:enter_site_error)
    flash.delete(:alert)
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end

  # private :check_recaptcha
  def check_recaptcha
    if Hancock.config.recaptcha_support and (!Rails.env.development? or Hancock.config.captcha_on_development)
      unless verify_recaptcha
        set_login_password_errors
        @recaptcha_error = I18n.t("shared.are_you_robot").freeze
        respond_with_navigational(resource) { render :new }
      end
    end
  end

  private
  def set_login_password_errors(login_key = :email)
    if login_key.is_a?(Hash)
      login_key = login_key[:login_key]
    end
    self.resource ||= resource_class.new(sign_in_params)
    if login_key.is_a?(Array)
      login_key.each do |key|
        resource.errors.add(key, I18n.t("shared.incorrect_email_or_password").freeze)
      end
    else
      resource.errors.add(login_key, I18n.t("shared.incorrect_email_or_password").freeze)
    end
    resource.errors.add(:password, I18n.t("shared.incorrect_email_or_password").freeze)
  end

  include Hancock::Decorators::Sessions

end
