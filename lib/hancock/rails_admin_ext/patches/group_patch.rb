require 'rails_admin'
module RailsAdmin
  module Config
    module Fields

      class Group
        register_instance_option :weight do
          name.to_sym == :default ? -1_000_000 : 0
        end

        def visible_fields
          section.with(bindings).visible_fields.select { |f|
            f.group == self
          }.sort do |a, b|
            a.weight <=> b.weight
          end
        end

        def group(name, &block)
          _groups = parent.groups rescue root.groups
          group = _groups.detect { |g| name == g.name }
          group ||= (parent.groups << RailsAdmin::Config::Fields::Group.new(self, name)).last
          group.tap { |g| g.section = self }.instance_eval(&block) if block
          group
        end

      end

    end
  end
end

module RailsAdmin
  module Config
    module HasGroups

      def visible_groups
        parent.groups.collect { |f|
          f.section = self
          f.with(bindings)
        }.select { |g|
          g.visible? and g.visible_fields.present?
        }.sort do |a, b|
          a.weight <=> b.weight
        end
      end

    end
  end
end
