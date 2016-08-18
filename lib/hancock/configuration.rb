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
    attr_accessor :menu_max_depth

    attr_accessor :localize

    attr_accessor :ability_manager_config
    attr_accessor :ability_admin_config

    attr_accessor :admin_enter_captcha
    attr_accessor :registration_captcha
    attr_accessor :recaptcha_support
    attr_accessor :simple_captcha_support

    def initialize
      @main_index_layout = 'application'
      @error_layout = 'application'
      @menu_max_depth = 2

      @localize = false

      @ability_manager_config = []
      @ability_manager_config << {
        method: :can,
        model: RailsAdminSettings::Setting,
        actions: [:edit, :update]
      }
      @ability_admin_config = []
      @ability_admin_config << {
        method: :can,
        model: RailsAdminSettings::Setting,
        actions: :manage
      }

      @recaptcha_support = defined?(Recaptcha)
      @simple_captcha_support = defined?(SimpleCaptcha)

      @admin_enter_captcha = @recaptcha_support or @simple_captcha_support
      @registration_captcha = @admin_enter_captcha

    end
  end
end
