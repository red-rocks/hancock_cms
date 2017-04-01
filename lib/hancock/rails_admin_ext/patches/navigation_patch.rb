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
