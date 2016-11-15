module Hancock
  include Hancock::PluginConfiguration

  def self.config_class
    Configuration
  end

  def self.configure
    yield configuration
    Hancock::PLUGINS.map(&:reconfigure!)
  end


  class Configuration
    attr_accessor :main_index_layout
    attr_accessor :error_layout

    attr_accessor :localize

    attr_accessor :ability_manager_config
    attr_accessor :ability_admin_config

    attr_accessor :admin_enter_captcha
    attr_accessor :registration_captcha
    attr_accessor :recaptcha_support
    attr_accessor :simple_captcha_support

    attr_accessor :captcha_on_development

    def initialize
      @main_index_layout = 'application'
      @error_layout = 'application'

      @localize = false

      @ability_manager_config = []
      @ability_admin_config = []

      @recaptcha_support = defined?(Recaptcha)
      @simple_captcha_support = defined?(SimpleCaptcha)

      @admin_enter_captcha = @recaptcha_support or @simple_captcha_support
      @registration_captcha = @admin_enter_captcha

      @captcha_on_development = false
    end
  end
end
