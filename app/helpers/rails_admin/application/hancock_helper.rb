# require 'rails_admin/application_helper'
module RailsAdmin::Application
  module HancockHelper

    def hancock_navigation(nodes_stack, nodes, level = 0)
      nodes.collect do |node|
        model_param = node.abstract_model.to_param
        url         = rails_admin.url_for(action: :index, controller: 'rails_admin/main', model_name: model_param)
        level_class = " nav-level-#{level}" if level > 0
        # nav_icon = node.navigation_icon ? %(<i class="#{node.navigation_icon}"></i>).html_safe : ''
        nav_icon = %(<i class="#{node.navigation_icon}"></i>).html_safe
        li = content_tag :li, data: {model: model_param, "name-synonyms": node.name_synonyms} do
          # alt version with icon new window open
          # ret = []
          # ret << (link_to nav_icon + capitalize_first_letter(node.label_plural), url, class: "pjax#{level_class}", title: capitalize_first_letter(node.label_plural))
          # ret << (link_to "_blank", url, target: :_blank, title: "#{capitalize_first_letter(node.label_plural)} (В новой вкладке)")
          # ret.join.html_safe
          link_name = nav_icon + capitalize_first_letter(node.label_plural)
          title = capitalize_first_letter(node.label_plural)
          title = "#{title} (#{node.abstract_model.model_name})" if _current_user and _current_user.admin?
          link_to link_name, url, class: "pjax#{level_class}", title: title
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


    
    def hancock_root_navigation
      return "".html_safe if Hancock.rails_admin1?
      _actions = actions(:root).select(&:show_in_sidebar).group_by(&:sidebar_label)
      _actions.collect do |label, nodes|
        li_stack = nodes.map do |node|
          url = rails_admin.url_for(action: node.action_name, controller: "rails_admin/main")
          nav_icon = node.link_icon ? %(<i class="#{node.link_icon}"></i>).html_safe : ''
          content_tag :li do
            link_to nav_icon + " " + wording_for(:menu, node), url, class: "pjax"
          end
        end.join.html_safe
        label ||= t('admin.misc.root_navigation')

        %(<li class='dropdown-header'>#{capitalize_first_letter label}</li>#{li_stack}) if li_stack.present?
      end.join.html_safe
    end

  end
end
