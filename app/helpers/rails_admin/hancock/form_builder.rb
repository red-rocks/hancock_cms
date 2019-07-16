require 'rails_admin/form_builder'
module RailsAdmin::Hancock
  class FormBuilder < ::RailsAdmin::FormBuilder

    def generate_tabbed(options = {})
      is_tabbed = true
      
      without_field_error_proc_added_div do
        options.reverse_merge!(
          action: @template.controller.params[:action],
          model_config: @template.instance_variable_get(:@model_config),
          nested_in: false,
        )

        action_name = @template.controller.params[:action]
        _params = @template.controller.params.permit!
        fieldset_name = (_params[:fieldset] || :default).to_sym
        all_groups = visible_groups(options[:model_config], generator_action(options[:action], options[:nested_in]))
        current_groups = all_groups.select do |fieldset|
          (is_tabbed and ((fieldset_name.blank? or fieldset_name == fieldset.name.to_sym) or (fieldset.bindings[:object].id.to_s != _params[:id]))) or !is_tabbed
        end.uniq
        buttons_locals = {
          hide_add_another: is_tabbed,
          hide_add_edit: is_tabbed
        }
        object_infos +
          ((!options[:nested_in] and is_tabbed) ? @template.content_tag(:ul, class: 'fieldset-list') do
            all_groups.collect do |fieldset|
              root_fieldset = (fieldset.bindings[:object].id.to_s == _params[:id])
              _class = "#{"pjax" if root_fieldset} #{"current" if current_groups.include?(fieldset)}"
              _url = (root_fieldset ? @template.url_for(_params.merge(fieldset: fieldset.name, return_to: nil)) : nil)
              @template.content_tag :li, fieldset.label, data: {target: fieldset.name, href: _url}, class: _class
            end.join.html_safe
          end : "") + 
          ((options[:nested_in] or !is_tabbed) ? '' : @template.render(partial: 'rails_admin/main/submit_buttons', locals: buttons_locals)) +
          current_groups.collect do |fieldset|
            fieldset_for fieldset, options[:nested_in]
          end.join.html_safe +
          (options[:nested_in] ? '' : @template.render(partial: 'rails_admin/main/submit_buttons', locals: buttons_locals))
      end
    end

    def generate(options = {})
      is_tabbed = (action_name == "tabbed_edit") and !options[:nested_in]
      return generate_tabbed(options) if is_tabbed

      without_field_error_proc_added_div do
        options.reverse_merge!(
          action: @template.controller.params[:action],
          model_config: @template.instance_variable_get(:@model_config),
          nested_in: false,
        )

        action_name = @template.controller.params[:action]
        _params = @template.controller.params.permit!
        all_groups = visible_groups(options[:model_config], generator_action(options[:action], options[:nested_in]))
        current_groups = all_groups.uniq
        
        object_infos +
          current_groups.collect do |fieldset|
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
        contents = []
        contents << @template.content_tag(:legend, %(<i class="icon-chevron-#{((fieldset.active? or (!nested_in and is_tabbed)) ? 'down' : 'right')}"></i> #{fieldset.label}).html_safe, style: fieldset.name == :default ? 'display:none' : '') if !is_tabbed or nested_in
        contents << @template.content_tag(:p, fieldset.help) if fieldset.help.present?
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

    def is_tabbed
      return @is_tabbed unless @is_tabbed.nil?
      @is_tabbed = (action_name == "tabbed_edit" or action_name == "hancock_tabbed_edit")
    end

    def action_name
      @action_name ||= @template.controller.params[:action]
    end

  end
end
