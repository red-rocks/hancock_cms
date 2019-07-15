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

      action_unvisible_for(:custom_show_in_app)
      action_visible_for(:model_settings, Proc.new {
        visible do
          abstract_model = (bindings and bindings[:abstract_model])
          # !!(abstract_model and abstract_model.model.respond_to?("settings"))
          !!(abstract_model and abstract_model.model.included_modules.include?(RailsAdminModelSettings::ModelSettingable))
        end
      })
      
      if defined?(RailsAdminNestedSet)
        action_visible_for(:nested_set)
      end

      if defined?(RailsAdminMultipleFileUpload)
        action_visible_for(:multiple_file_upload)
        action_visible_for(:multiple_file_upload_collection)
      end

      if defined?(RailsAdminUserAbilities)
        action_visible_for(:user_abilities)
        action_visible_for(:model_accesses)
      end

      if defined?(RailsAdminComments)
        action_visible_for(:comments)
        action_visible_for(:model_comments)
      end

      action_visible_for(:sort_embedded)

      # action_visible_for(:hancock_management, Proc.new { |config|
      action_visible_for(:hancock_management, Proc.new {
        visible do
          _context = (bindings and (bindings[:controller] || bindings[:view]))
          !!(_context and _context._current_user and _context._current_user.admin?)
        end
      })

      if Hancock.config.model_settings_support
        action_visible_for(:object_settings, Proc.new {
          visible do
            abstract_model = (bindings and bindings[:abstract_model])
            !!(abstract_model and abstract_model.model.relations.has_key?("settings"))
          end
        })
      end
      
      action_visible_for(:hancock_tabbed_edit)

      # action_visible_for(:hancock_backup, Proc.new { |config|
      action_visible_for(:hancock_backup, Proc.new {
        visible do
          _context = (bindings and (bindings[:controller] || bindings[:view]))
          !!(_context and _context._current_user and _context._current_user.admin?)
        end
      })
    end



    def add_action(action_name)
      @actions_list << action_name
      @actions_list.uniq
    end

    def remove_action(action_name)
      @actions_list.delete action_name
      @actions_list.uniq
    end

    def action_visible_for(action_name, model_name = false)
      # action_name = action_name
      add_action(action_name) unless @actions_list.include?(action_name)
      model_name = Proc.new {
        visible do
          true
        end
      } if model_name.nil?

      @actions_visibility[action_name] ||= []
      if model_name
        if model_name.is_a?(Proc)
          @actions_visibility[action_name] = model_name
        else
          @actions_visibility[action_name] = [] if @actions_visibility[action_name].is_a?(Proc)
          @actions_visibility[action_name] ||= []
          @actions_visibility[action_name] << model_name.to_s
        end
      end
    end
    

    def action_unvisible_for(action_name, model_name = false)
      action_name = action_name.to_sym
      add_action(action_name) unless @actions_list.include?(action_name)
      model_name = Proc.new {
        visible do
          true
        end
      } if model_name.nil?
      
      if model_name
        if model_name.is_a?(Proc)
          @actions_visibility[action_name] = [] # if @actions_visibility[action_name].is_a?(Proc)
        else
          @actions_visibility[action_name] ||= []
          @actions_visibility[action_name].delete model_name.to_s
        end
      else
        @actions_visibility[action_name] = []
      end

      if @actions_visibility[action_name].blank?
        @actions_visibility.delete(action_name)
        remove_action(action_name)
      end
    end


    def actions_config(ra_context)

      @actions_list.each do |action|
        scope = nil
        if action.is_a?(Hash)
          scope = action.keys.first
          action = action.values.first
        end
        if ra_context.respond_to?(action) and !RailsAdmin::Config::Actions.all.map { |a| a.class.name.demodulize.underscore }.include?(action.to_s)
          if scope
            rails_admin_scoped_action(ra_context, scope, action)
          else
            rails_admin_action(ra_context, action)
          end
        end
      end

    end



    def rails_admin_scoped_action(ra_context, scope, action)
      rails_admin_action(ra_context, [scope, action])
    end
    def rails_admin_action(ra_context, action)
      ra_field_opts = Array(action).compact
      action = ra_field_opts.last
      visibility = Hancock.rails_admin_config.actions_visibility[action]

      if visibility.is_a?(Proc)
        # ra_field_opts << visibility 
        ra_context.send(*ra_field_opts) do
          # visibility.call(self)
          instance_eval &visibility
        end

      else
        ra_context.send(*ra_field_opts) do
          ret = false
          visible do
            ret = false
            abstract_model = (bindings and bindings[:abstract_model])
            ret ||= if abstract_model
              if abstract_model.model.respond_to?(:rails_admin_visible_actions)
                abstract_model.model.rails_admin_visible_actions.include?(action.to_sym)
              end
            end # ret = if abstract_model
            _context = (bindings and (bindings[:controller] || bindings[:view]))
            !!(ret and _context and abstract_model and _context.can?(action, abstract_model.model))
          end 
        end
      end 
      
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
