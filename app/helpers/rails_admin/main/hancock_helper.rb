require 'rails_admin/main_helper'
module RailsAdmin::Main
  module HancockHelper

    def hancock_rails_admin_form_for(*args, &block)
      options = args.extract_options!.reverse_merge(builder: RailsAdmin::Hancock::FormBuilder)
      (options[:html] ||= {})[:novalidate] ||= !RailsAdmin::Config.browser_validations

      form_for(*(args << options), &block) << after_nested_form_callbacks
    end

  end
end
