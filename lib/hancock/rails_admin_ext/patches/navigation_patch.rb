require 'rails_admin'
module RailsAdmin
  module Config

    class Model
      register_instance_option :navigation_icon do
        abstract_model.model.try('rails_admin_navigation_icon')
      end

      register_instance_option :name_synonyms do
        if name_synonyms_method
          ret = abstract_model.model.try(name_synonyms_method)
          ret = ret.join(" ") if ret.is_a?(Array)
        else
          ret = ''
        end
        ret.freeze
      end
      register_instance_option :name_synonyms_method do
        :rails_admin_name_synonyms
      end
    end

  end
end


module Hancock
  module RailsAdminApplicationHelperNavigationPatch
    extend ActiveSupport::Concern

    included do
      def navigation(nodes_stack, nodes, level = 0)
        nodes.collect do |node|
          model_param = node.abstract_model.to_param
          url         = rails_admin.url_for(action: :index, controller: 'rails_admin/main', model_name: model_param)
          level_class = " nav-level-#{level}" if level > 0
          nav_icon = node.navigation_icon ? %(<i class="#{node.navigation_icon}"></i>).html_safe : ''
          li = content_tag :li, data: {model: model_param, "name-synonyms": node.name_synonyms} do
            link_to nav_icon + capitalize_first_letter(node.label_plural), url, class: "pjax#{level_class}", title: capitalize_first_letter(node.label_plural)
          end
          li + navigation(nodes_stack, nodes_stack.select { |n| n.parent.to_s == node.abstract_model.model_name }, level + 1)
        end.join.html_safe
      end
    end

  end
end
