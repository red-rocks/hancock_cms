require 'rails_admin'
module RailsAdmin
  module Config
    module Fields

      class Group
        register_instance_option :leftside_hider do
          true
        end
      end

    end
  end
end


module Hancock
  module RailsAdminFormBuilderFieldsetPatch
    extend ActiveSupport::Concern

    included do

      def fieldset_for(fieldset, nested_in)
        fields = fieldset.with(
          form: self,
          object: @object,
          view: @template,
          controller: @template.controller,
        ).visible_fields
        return if fields.empty?

        _defailt_fieldset = fieldset.name == :default
        @template.content_tag :fieldset, class: _defailt_fieldset ? 'default_fieldset' : '' do
          if fieldset.leftside_hider
            # leftside_hider = @template.content_tag(:div, class: 'control-group leftside_hider', style: _defailt_fieldset ? 'display:none' : '', title: "Свернуть блок") do
            leftside_hider = @template.content_tag(:div, class: 'control-group leftside_hider', title: _defailt_fieldset ? "" : "Свернуть блок") do
              # @template.content_tag(:div, class: 'scroll_fieldset_block', style: 'top: 50%') do
              @template.content_tag(:div, class: 'scroll_fieldset_block') do
                ret = []
                ret << @template.content_tag(:div, class: 'scroll_fieldset_top', title: "Вверх блока") do
                  @template.content_tag(:i, "", class: 'fa fa-arrow-up')
                end
                ret << @template.content_tag(:div, class: 'select_fieldset', title: "Выбрать другой блок") do
                  @template.content_tag(:i, "", class: 'fa fa-indent')
                end
                ret << @template.content_tag(:div, class: 'scroll_fieldset_bottom', title: "Вниз блока") do
                  @template.content_tag(:i, "", class: 'fa fa-arrow-down')
                end
                ret.join.html_safe
              end
            end
          end

          contents = []
          contents << @template.content_tag(:legend, %(<i class="icon-chevron-#{(fieldset.active? ? 'down' : 'right')}"></i> #{fieldset.label}).html_safe, style: fieldset.name == :default ? 'display:none' : '')
          contents << @template.content_tag(:p, fieldset.help) if fieldset.help.present?
          contents << leftside_hider if fieldset.leftside_hider and leftside_hider
          contents << fields.collect { |field| field_wrapper_for(field, nested_in) }.join
          contents.join.html_safe
        end
      end

    end
  end
end
