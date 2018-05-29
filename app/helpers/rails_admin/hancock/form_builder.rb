require 'rails_admin/form_builder'
module RailsAdmin::Hancock
  class FormBuilder < ::RailsAdmin::FormBuilder

    def generate(options = {})
      without_field_error_proc_added_div do
        options.reverse_merge!(
          action: @template.controller.params[:action],
          model_config: @template.instance_variable_get(:@model_config),
          nested_in: false,
        )

        object_infos +
          visible_groups(options[:model_config], generator_action(options[:action], options[:nested_in])).select do |fieldset|
            options[:fieldsets].nil? or options[:fieldsets].blank? or options[:fieldsets].include?(fieldset.name)
          end.collect do |fieldset|
            fieldset_for fieldset, options[:nested_in]
          end.join.html_safe +
          (options[:nested_in] ? '' : @template.render(partial: 'rails_admin/main/submit_buttons'))
      end
    end

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


    def input_for(field)
      field_name_type_selector = [
        @object_name.to_s.gsub(/\]\[|[^-a-zA-Z0-9:.]/, '_').sub(/_$/, ''),
        options[:index],
        field.method_name
      ].reject(&:blank?).join('_')
      css = "col-sm-10 controls #{field_name_type_selector}"
      css += ' has-error' if field.errors.present?
      @template.content_tag(:div, class: css) do
        field_for(field) +
          errors_for(field) +
          help_for(field)
      end
    end



    def dom_id(field)
      (@dom_id ||= {})[field.name] ||= [
        @object_name.to_s.gsub(/\]\[|[^-a-zA-Z0-9:.]/, '_').sub(/_$/, ''),
        (self.object.new_record? ?  nil : self.object.id.to_s),
        options[:index],
        field.method_name,
      ].reject(&:blank?).join('_')
    end

  end
end
