# require 'rails_admin/main_helper'
module RailsAdmin::Hancock
  module MainHelper

    def hancock_rails_admin_form_for(*args, &block)
      options = args.extract_options!.reverse_merge(builder: RailsAdmin::Hancock::FormBuilder)
      (options[:html] ||= {})[:novalidate] ||= !RailsAdmin::Config.browser_validations

      form_for(*(args << options), &block) << after_nested_form_callbacks
    end

    def ordered_nodes_stack(nodes_stack = nil, node_model_names = nil)
      _controller = (defined?(controller) ? controller : self)
      nodes_stack ||= RailsAdmin::Config.visible_models(controller: _controller)
      node_model_names ||= nodes_stack.collect { |c| c.abstract_model.model_name }

      hancock_navigation_labels = Hancock.config.navigation_labels.clone

      _order_array = _controller._current_user.navigation_labels.clone if _controller._current_user and _controller._current_user.respond_to?(:navigation_labels)
      _order_array = hancock_navigation_labels.clone if _order_array.blank?
      _order_array.map! { |label|
        detected = hancock_navigation_labels.detect { |n_l|
          (label == n_l or (n_l.is_a?(Array) and label == n_l[1]))
        }
        hancock_navigation_labels.delete(detected) || label || []
      }
      _order_array += hancock_navigation_labels
      _order_array = _order_array.clone.reverse

      ret = {}
      grouped_nodes_stack = nodes_stack.group_by(&:navigation_label)
      navigation_labels = grouped_nodes_stack.keys
      navigation_labels.sort! do |label_1, label_2|
        label_1_index = _order_array.index { |label| label == label_1 or label[1] == label_1 } || -1
        label_2_index = _order_array.index { |label| label == label_2 or label[1] == label_2 } || -1
        label_2_index <=> label_1_index
      end
      navigation_labels.each do |label|
        nav_label = _order_array.detect { |n_l|
          label == n_l or n_l.is_a?(Array) and label == n_l[1]
        }
        ret[label] = [nav_label, grouped_nodes_stack[label]]
      end
      
      ret
      # user_favorited_navigation = current_user.respond_to?(:favorited_navigation) ? current_user.favorited_navigation : {}
      # puts ret.class.inspect
      # user_favorited_navigation.merge(ret)
    end

    def hancock_main_navigation
      nodes_stack = RailsAdmin::Config.visible_models(controller: controller)
      node_model_names = nodes_stack.collect { |c| c.abstract_model.model_name }
      _ordered_nodes_stack = ordered_nodes_stack(nodes_stack, node_model_names)

      _ordered_nodes_stack.collect do |navigation_label, label_n_nodes|
        label = label_n_nodes[0]
        nodes = label_n_nodes[1].select { |n| n.parent.nil? || !n.parent.to_s.in?(node_model_names) }
        li_stack = hancock_navigation nodes_stack, nodes

        if label.is_a?(Array)
          navigation_label_class, navigation_label = label[0], label[1]
        else
          navigation_label_class = nil
        end

        label = navigation_label || t('admin.misc.navigation')
        label_class = navigation_label_class || t('admin.misc.navigation_label_class')

        span = "<span>#{capitalize_first_letter label}</span>"
        ul = "<ul>#{li_stack}</ul>"
        %(<li class='dropdown-header #{label_class}' title='#{capitalize_first_letter label}'>#{span}<i class="mdi mdi-dots-horizontal"></i>#{ul}</li>) if li_stack.present?
      end.join.html_safe
    end

    # done
    def hancock_menu_for(parent, abstract_model = nil, object = nil, only_icon = false) # perf matters here (no action view trickery)
      # actions = actions(parent, abstract_model, object).select { |a| a.http_methods.include?(:get) }
      _actions = actions(parent, abstract_model, object)
      _actions =  if Hancock.rails_admin1?
        _actions.select { |a| a.http_methods.include?(:get) }
      elsif Hancock.rails_admin2? or true
        _actions.select { |a| a.http_methods.include?(:get) && a.show_in_menu }
      else
        []
      end
      _actions.collect do |action|
        wording = wording_for(:menu, action)
        url = rails_admin.url_for(action: action.action_name, 
          controller: 'rails_admin/main', 
          model_name: abstract_model.try(:to_param), 
          id: (object.try(:persisted?) && object.try(:id) || nil), 
          # embedded_in: params[:embedded_in]
        )
        # <span#{only_icon ? " style='display:none'" : ''}>#{wording}</span>
        %(
          <li title="#{wording}" rel="#{'tooltip' if only_icon}" class="icon #{action.key}_#{parent}_link #{'active' if current_action?(action)}">
            <a class="#{action.pjax? ? 'pjax' : ''}" href="#{url}">
              <i class="#{action.link_icon}"></i>
              <span#{only_icon ? " style=''" : ''}>#{wording}</span>
            </a>
          </li>
        )
      end.join.html_safe
    end


    # RailsAdmin 2 support
    def filterable_fields
      @filterable_fields ||= @model_config.list.fields.select(&:filterable?)
    end

    def ordered_filters
      return @ordered_filters if @ordered_filters.present?
      @index = 0
      @ordered_filters = (params[:f].try(:permit!).try(:to_h) || @model_config.list.filters).inject({}) do |memo, filter|
        field_name = filter.is_a?(Array) ? filter.first : filter
        (filter.is_a?(Array) ? filter.last : {(@index += 1) => {'v' => ''}}).each do |index, filter_hash|
          if filter_hash['disabled'].blank?
            memo[index] = {field_name => filter_hash}
          else
            params[:f].delete(field_name)
          end
        end
        memo
      end.to_a.sort_by(&:first)
    end

    def ordered_filter_options
      @ordered_filter_options ||= ordered_filters.map do |duplet|
        options = {index: duplet[0]}
        filter_for_field = duplet[1]
        filter_name = filter_for_field.keys.first
        filter_hash = filter_for_field.values.first
        unless (field = filterable_fields.find { |f| f.name == filter_name.to_sym })
          raise "#{filter_name} is not currently filterable; filterable fields are #{filterable_fields.map(&:name).join(', ')}"
        end
        case field.type
        when :enum
          options[:select_options] = options_for_select(field.with(object: @abstract_model.model.new).enum, filter_hash['v'])
        when :date, :datetime, :time
          options[:datetimepicker_format] = field.parser.to_momentjs
        end
        options[:label] = field.label
        options[:name]  = field.name
        options[:type]  = field.type
        options[:value] = filter_hash['v']
        options[:label] = field.label
        options[:operator] = filter_hash['o']
        options
      end if ordered_filters
    end


  end
end
