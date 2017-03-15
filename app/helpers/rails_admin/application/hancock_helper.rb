require 'rails_admin/application_helper'
module RailsAdmin::Application
  module HancockHelper

    def hancock_navigation(nodes_stack, nodes, level = 0)
      nodes.collect do |node|
        model_param = node.abstract_model.to_param
        url         = rails_admin.url_for(action: :index, controller: 'rails_admin/main', model_name: model_param)
        level_class = " nav-level-#{level}" if level > 0
        nav_icon = node.navigation_icon ? %(<i class="#{node.navigation_icon}"></i>).html_safe : ''
        li = content_tag :li, data: {model: model_param, "name-synonyms": node.name_synonyms} do
          link_to nav_icon + capitalize_first_letter(node.label_plural), url, class: "pjax#{level_class}", title: capitalize_first_letter(node.label_plural)
        end
        li + hancock_navigation(nodes_stack, nodes_stack.select { |n| n.parent.to_s == node.abstract_model.model_name }, level + 1)
      end.join.html_safe
    end

    def hancock_main_navigation
      nodes_stack = RailsAdmin::Config.visible_models(controller: controller)
      node_model_names = nodes_stack.collect { |c| c.abstract_model.model_name }

      nodes_stack.group_by(&:navigation_label).collect do |navigation_label, nodes|
        nodes = nodes.select { |n| n.parent.nil? || !n.parent.to_s.in?(node_model_names) }
        li_stack = hancock_navigation nodes_stack, nodes

        label = navigation_label || t('admin.misc.navigation')

        %(<li class='dropdown-header'>#{capitalize_first_letter label}</li>#{li_stack}) if li_stack.present?
      end.join.html_safe
    end


  end
end
