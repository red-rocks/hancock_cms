require 'rails_admin/main_helper'
module RailsAdmin::Main
  module HancockHelper

    def hancock_rails_admin_form_for(*args, &block)
      options = args.extract_options!.reverse_merge(builder: RailsAdmin::Hancock::FormBuilder)
      (options[:html] ||= {})[:novalidate] ||= !RailsAdmin::Config.browser_validations

      form_for(*(args << options), &block) << after_nested_form_callbacks
    end

    def hancock_main_navigation
      nodes_stack = RailsAdmin::Config.visible_models(controller: controller)
      node_model_names = nodes_stack.collect { |c| c.abstract_model.model_name }

      _order_array = controller._current_user.navigation_labels
      _order_array ||= Hancock.config.navigation_labels
      _order_array = _order_array.clone.reverse

      ordered_nodes_stack = {}
      grouped_nodes_stack = nodes_stack.group_by(&:navigation_label)
      navigation_labels = grouped_nodes_stack.keys
      navigation_labels.sort! do |label_1, label_2|
        label_1_index = _order_array.index(label_1) || -1
        label_2_index = _order_array.index(label_2) || -1
        label_2_index <=> label_1_index
      end
      navigation_labels.each do |label|
        ordered_nodes_stack[label] = grouped_nodes_stack[label]
      end

      ordered_nodes_stack.collect do |navigation_label, nodes|
        nodes = nodes.select { |n| n.parent.nil? || !n.parent.to_s.in?(node_model_names) }
        li_stack = hancock_navigation nodes_stack, nodes

        label = navigation_label || t('admin.misc.navigation')

        %(<li class='dropdown-header'>#{capitalize_first_letter label}</li>#{li_stack}) if li_stack.present?
      end.join.html_safe
    end

  end
end
