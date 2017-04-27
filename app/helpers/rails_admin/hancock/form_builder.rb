require 'rails_admin/form_builder'
module RailsAdmin::Hancock
  class FormBuilder < ::RailsAdmin::FormBuilder

    def fieldset_for(fieldset, nested_in)
      fields = fieldset.with(
        form: self,
        object: @object,
        view: @template,
        controller: @template.controller,
      ).visible_fields
      return if fields.empty?

      _default_fieldset = fieldset.name == :default
      @template.content_tag :fieldset, class: _default_fieldset ? 'default_fieldset' : '' do
        if fieldset.leftside_hider and !nested_in
          leftside_hider = @template.content_tag(:div, class: 'control-group leftside_hider', title: _default_fieldset ? "" : "Свернуть блок") do
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
