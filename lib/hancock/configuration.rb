module Hancock
  include Hancock::PluginConfiguration

  def self.configuration(plugin_name = nil)
    return @configuration ||= config_class.new if config_class if plugin_name.blank?

    @plugins_cache ||= {}
    _plugin = nil
    _plugin = plugin_name if Hancock::PLUGINS.include?(plugin_name)
    if _plugin.nil?
      plugin_name = plugin_name.to_s.camelize
      return _plugin.config unless (_plugin = @plugins_cache[plugin_name]).nil?
      if Object.const_defined?(plugin_name)
        _plugin_name_const = plugin_name.constantize
        _plugin = _plugin_name_const if Hancock::PLUGINS.include?(_plugin_name_const) or _plugin_name_const == Hancock
      end
    end
    if _plugin.nil?
      if Object.const_defined?("Hancock::#{plugin_name}")
        _plugin_name_const = "Hancock::#{plugin_name}".constantize
        _plugin = _plugin_name_const if Hancock::PLUGINS.include?(_plugin_name_const)
      end
    end
    if _plugin
      @plugins_cache[plugin_name] = _plugin
      return _plugin.config
    end
    return nil
  end
  def self.config(plugin_name = nil)
    configuration(plugin_name)
  end

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
    attr_accessor :raven_support

    attr_accessor :ability_manager_config
    attr_accessor :ability_admin_config

    attr_accessor :admin_enter_captcha
    attr_accessor :registration_captcha
    attr_accessor :recaptcha_support
    attr_accessor :simple_captcha_support

    attr_accessor :captcha_on_development

    attr_accessor :history_tracking

    attr_accessor :mongoid_single_collection

    attr_accessor :navigation_labels

    attr_accessor :erb2coffee_assets

    def initialize
      @main_index_layout = 'application'
      @error_layout = 'application'

      @localize = !!defined?(RailsAdminMongoidLocalizeField) #false
      @raven_support = !!defined?(Raven)

      @ability_manager_config = []
      @ability_admin_config = []

      @recaptcha_support = !!defined?(Recaptcha)
      @simple_captcha_support = !!defined?(SimpleCaptcha)

      @admin_enter_captcha = @recaptcha_support or @simple_captcha_support
      @registration_captcha = @admin_enter_captcha

      @captcha_on_development = false

      @history_tracking = true

      @mongoid_single_collection = nil

      @navigation_labels = []

      @erb2coffee_assets = ['hancock/rails_admin/plugins.coffee.erb']

    end
  end
end
