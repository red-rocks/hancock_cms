module Hancock
  module Admin
    module EmbeddedElement

      def self.config(nav_label = nil, fields = {})
        if nav_label.is_a?(Hash)
          nav_label, fields = nav_label[:nav_label], nav_label
        elsif nav_label.is_a?(Array)
          nav_label, fields = nil, nav_label
        end
        fields ||= {}
        field_names = [:enabled, :name]
        field_showings = Hancock::Admin.get_field_showings(fields, field_names)

        Proc.new {
          navigation_label(nav_label || I18n.t('hancock.cms'))
          field :enabled, :toggle do
            searchable false
          end if field_showings[:enabled]
          field :name, :string do
            searchable true
          end if field_showings[:name]

          Hancock::RailsAdminGroupPatch::hancock_cms_group(self, fields)

          if block_given?
            yield self
          end
        }
      end

    end
  end
end
