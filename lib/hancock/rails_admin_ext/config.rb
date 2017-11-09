module Hancock
  class << self
    def rails_admin_configuration
      @rails_admin_configuration ||= RailsAdminConfiguration.new
    end
    def rails_admin_config
      @rails_admin_configuration ||= RailsAdminConfiguration.new
    end
    def rails_admin_configure
      yield rails_admin_configuration
    end

    def action_visible_for(action_name, model_name)
      rails_admin_config.action_visible_for action_name, model_name
    end
    def action_unvisible_for(action_name, model_name)
      rails_admin_config.action_unvisible_for action_name, model_name
    end

    def rails_admin_config_for_actions(actions)
      rails_admin_config.actions_config(actions)
    end

    def cancancan_admin_rules(ability_object)
      rails_admin_config.cancancan_admin_rules(ability_object)
    end
    def cancancan_manager_rules(ability_object)
      rails_admin_config.cancancan_manager_rules(ability_object)
    end
  end

  class RailsAdminConfiguration

    attr_reader :actions_list
    attr_reader :actions_visibility

    def initialize
      @actions_list ||= []
      @actions_visibility ||= {}

      action_unvisible_for(:custom_show_in_app, Proc.new { false })
      action_visible_for(:model_settings, Proc.new { true })

      if defined?(RailsAdminNestedSet)
        action_visible_for(:nested_set, Proc.new { true })
      end

      if defined?(RailsAdminMultipleFileUpload)
        action_visible_for(:multiple_file_upload, Proc.new { true })
        action_visible_for(:multiple_file_upload_collection, Proc.new { true })
      end

      if defined?(RailsAdminUserAbilities)
        action_visible_for(:user_abilities, Proc.new { true })
        action_visible_for(:model_accesses, Proc.new { true })
      end

      if defined?(RailsAdminComments)
        action_visible_for(:comments, Proc.new { true })
        action_visible_for(:model_comments, Proc.new { true })
      end

      action_visible_for(:sort_embedded, Proc.new { true })

      action_visible_for(:hancock_management, Proc.new { |config|
        bindings = (config and config.bindings)
        _context = (bindings and (bindings[:controller] || bindings[:view]))
        _context._current_user and _context._current_user.admin?
      })

    end

    def add_action(action_name)
      @actions_list << action_name.to_sym
      @actions_list.uniq
    end

    def remove_action(action_name)
      @remove_action.delete remove_action.to_sym
      @actions_list.uniq
    end

    def action_visible_for(action_name, model_name)
      action_name = action_name.to_sym
      add_action(action_name) unless @actions_list.include?(action_name)

      if model_name.is_a?(Proc)
        @actions_visibility[action_name] = model_name
      else
        @actions_visibility[action_name] = [] if @actions_visibility[action_name].is_a?(Proc)
        @actions_visibility[action_name] ||= []
        @actions_visibility[action_name] << model_name.to_s
      end
    end

    def action_unvisible_for(action_name, model_name)
      action_name = action_name.to_sym
      add_action(action_name) unless @actions_list.include?(action_name)

      if model_name.is_a?(Proc)
        # @actions_visibility[action_name] = model_name
      else
        @actions_visibility[action_name] = [] if @actions_visibility[action_name].is_a?(Proc)
        @actions_visibility[action_name] ||= []
        @actions_visibility[action_name].delete model_name.to_s
      end
    end

    def actions_config(rails_admin_actions)

      @actions_list.each do |action|
        if rails_admin_actions.respond_to?(action) and !RailsAdmin::Config::Actions.all.map { |a| a.class.name.demodulize.underscore }.include?(action.to_s)
          rails_admin_actions.send(action) do
            visible do
              if !bindings or bindings[:abstract_model].blank?
                unless (visibility = Hancock.rails_admin_config.actions_visibility[action]).nil?
                  if visibility.is_a?(Proc)
                    visibility.call(self)
                  else
                    visibility
                  end
                else
                  true
                end
              else
                ret = false
                if bindings[:abstract_model].model.respond_to?(:rails_admin_visible_actions)
                  ret = bindings[:abstract_model].model.rails_admin_visible_actions.include?(action.to_sym)
                else
                  if visibility = Hancock.rails_admin_config.actions_visibility[action]
                    if visibility.is_a?(Proc)
                      ret = visibility.call(self)
                    else
                      ret = visibility.include? bindings[:abstract_model].model_name
                    end
                  end
                end # if bindings[:abstract_model].model.respond_to?(:rails_admin_visible_actions)
                _context = bindings[:controller] || bindings[:view]
                ret and _context and _context.can?(action, bindings[:abstract_model].model)
              end # !bindings or bindings[:abstract_model].blank?
            end # visible do
          end # rails_admin_actions.send(action) do
        end # if rails_admin_actions.respond_to?(action)
      end # @actions_list.each do |action|

    end


    def cancancan_admin_rules(ability_object)
      Hancock.config.ability_admin_config.each do |config|
        _model = config[:model]
        _model = _model.constantize if _model.is_a?(String)
        ability_object.send(config[:method], config[:actions], _model)
      end
      Hancock::MODELS.each do |_model|
        ability_object.can    _model.admin_can_actions,     _model
        ability_object.cannot _model.admin_cannot_actions,  _model
      end
    end

    def cancancan_manager_rules(ability_object)
      Hancock.config.ability_manager_config.each do |config|
        _model = config[:model]
        _model = _model.constantize if _model.is_a?(String)
        ability_object.send(config[:method], config[:actions], _model)
      end
      Hancock::MODELS.each do |_model|
        ability_object.can    _model.manager_can_actions,     _model
        ability_object.cannot _model.manager_cannot_actions,  _model
      end
    end

  end
end

RailsAdmin::Config.total_columns_width = 570
