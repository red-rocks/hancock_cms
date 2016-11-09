require 'rails_admin'
module Hancock::RailsAdminGroupPatch
  class << self
    def hancock_cms_group(config, fields = {})
      return unless fields

      if fields.is_a?(Array)
        fields.reject { |f| f.empty? }.each do |_group|
          _name_default = :default
          _label_default = _name_default
          _name = _group.delete(:name) || _name_default
          _group[:label] = _group.delete(:label) || _label_default
          _active_default = _name == :default
          _group[:active] ||= _active_default
          _fields_default = {}
          _group_fields = (_group.delete(:fields) || _fields_default)

          config.group _name do
            _group.each_pair do |name, val|

              # TODO: find more logical solution
              begin
                begin
                  send name, val
                rescue
                  send name
                end
              end
            end

            _group_fields.each_pair do |name, type|
              if type.blank?
                field name
              else
                if type.is_a?(Array)
                  field name, type[0], &type[1]
                else
                  field name, type
                end
              end
            end


          end
        end

      else
        fields.each_pair do |name, type|
          if type.nil?
            config.field name
          else
            if type.is_a?(Array)
              config.field name, type[0], &type[1]
            else
              config.field name, type
            end
          end
        end
      end

    end
  end
end
