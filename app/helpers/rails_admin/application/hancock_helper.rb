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

    def hancock_show_path(obj, opts = {})
      if obj.is_a?(Hash)
        (opts ||= {}).merge!(obj)
      else
        (opts ||= {}).merge!({model_name: obj.rails_admin_model, id: obj.id})
      end
      show_path(opts)
    end

    def hancock_edit_path(obj, opts = {})
      if obj.is_a?(Hash)
        (opts ||= {}).merge!(obj)
      else
        (opts ||= {}).merge!({model_name: obj.rails_admin_model, id: obj.id})
      end
      edit_path(opts)
    end

  end
end
